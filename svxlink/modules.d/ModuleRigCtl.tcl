###############################################################################
#  OpenRepeater RigCtl Module
#  Coded by Aaron Crawford (N3MBH) & Gregg Daugherty (WB6YAZ)
#  DTMF Control of rigctl (hamlib 3.0.1) functions as defined below.
#
#  Usage:
#  01# = RIGCTL_1
#  02# = RIGCTL_2
#  ... etc
#
#  Visit the project at OpenRepeater.com
###############################################################################


# Start of namespace
namespace eval RigCtl {

	# Check if this module is loaded in the current logic core
	if {![info exists CFG_ID]} {
		return;
	}


	# Extract the module name from the current namespace
	set module_name [namespace tail [namespace current]]


	# A convenience function for printing out information prefixed by the module name
	proc printInfo {msg} {
		variable module_name
		puts "$module_name: $msg"
	}


	# A convenience function for calling an event handler
	proc processEvent {ev} {
		variable module_name
		::processEvent "$module_name" "$ev"
	}


	# Executed when this module is being activated
	proc activateInit {} {
		# Loop through config variables for rig control states and write into array, up to 8 states supported
		variable RIGCTL
		set n 1
		while {$n <= 8} {
			variable CFG_RIGCTL_$n
			if { ([info exists CFG_RIGCTL_$n]) && ([set CFG_RIGCTL_$n] > 0) } {
				set RIGCTL($n) [set CFG_RIGCTL_$n]
			}
		    set n [expr {$n + 1}]
		}


		# Access Variables
		#variable CFG_ACCESS_PIN
		#variable CFG_ACCESS_ATTEMPTS_ALLOWED
		#variable ACCESS_PIN_REQ
		#variable ACCESS_GRANTED
		#variable ACCESS_ATTEMPTS_ATTEMPTED
	  #  if {[info exists CFG_ACCESS_PIN]} {
		#	set ACCESS_PIN_REQ 1
		#	if {![info exists CFG_ACCESS_ATTEMPTS_ALLOWED]} { set CFG_ACCESS_ATTEMPTS_ALLOWED 3 }
		#} else {
		#	set ACCESS_PIN_REQ 0
		#}
		#set ACCESS_GRANTED 0
		#set ACCESS_ATTEMPTS_ATTEMPTED 0


		#printInfo "Module Activated"

		#if {$ACCESS_PIN_REQ == "1"} {
		#	printInfo "--- PLEASE ENTER YOUR PIN FOLLOWED BY THE POUND SIGN ---"
		#	playMsg "access_enter_pin";

		#} else {
		#	# No Pin Required but this is the first time the module has been run so play prompt
		#	playMsg "enter_command";
		#}

	}


	# Executed when this module is being deactivated.
	#proc deactivateCleanup {} {
	#	printInfo "Module deactivated"
  #
	#	variable RIGCTL_OFF_DEACTIVATION
	#	if {$RIGCTL_OFF_DEACTIVATION == "1"} {
	#		RigCtlDefault
	#	}
	#}


	# Returns voice status of RigCtl setting
	#proc RigCtlStatus {} {
	#	variable RIGCTL
	#	printInfo "STATUS RIGCTL STATE"
	#	playMsg "status";
	#	set RIGCTL_FILE [open "/home/root/rcvalue" r]
	#	set RIGCTL_STATE [read -nonewline $RIGCTL_FILE]
	#	printInfo "RIGCTL $RIGCTL_STATE ON"
	#	playMsg "rigctl";
	#	playMsg "$RIGCTL_STATE";
	#	playMsg "on";
	#	playSilence 700;
  #}


	# Proceedure to set default
	# proc RigCtlDefault {} {
	#	variable RIGCTL
	#	printInfo "SETTING DEFAULT"
	#	playMsg "rigctl_default";
	#	playMsg "on";
	#	exec rigctl {-m 370 -r /dev/ttyUSB0 F 146940000 M FM 6000}
	#	exec echo 1 > /home/root/rcvalue/rcvalue &
	# }


	# Proceedure to output rigctl command
	#proc setRigCtl {NUM} {
	#	variable RIGCTL
	#	if {RIGCTL($NUM) == 1} {
	#	  exec rigctl $RigCommand1
	#	} elseif {RIGCTL($NUM) ==2} {
	#	  exec rigctl $RigCommand2
	#	printInfo "RigCtl $NUM ON (RIGCTL: $RIGCTL($NUM))"
	#	playMsg "rigctl";
	#	playMsg "$NUM";
	#	playMsg "on";
	#	exec echo $NUM > /home/root/rcvalue/rcvalue &
	# }
	#}


	# Executed when a DTMF command is received
	proc changeRigState {cmd} {
		printInfo "DTMF command received: $cmd"

		variable RIGCTL

		if {$cmd == "01"} {
			exec rigctl {*}$RIGCTL(1)

		} elseif {$cmd == "02"} {
			exec rigctl {*}$RIGCTL(2)

		} elseif {$cmd == "03"} {
			exec rigctl {*}$RIGCTL(3)

		} elseif {$cmd == "04"} {
			exec rigctl {*}$RIGCTL(4)

		} elseif {$cmd == "05"} {
			exec rigctl {*}$RIGCTL(5)

		} elseif {$cmd == "06"} {
			exec rigctl {*}$RIGCTL(6)

		} elseif {$cmd == "07"} {
			exec rigctl {*}$RIGCTL(7)

		} elseif {$cmd == "08"} {
			exec rigctl {*}$RIGCTL(8)

		}	elseif {$cmd == ""} {
			deactivateModule

		} else {
			processEvent "unknown_command $cmd"
		}

	}

	# Execute when a DTMF Command is received and check for access.
	proc dtmfCmdReceived {cmd} {
		variable CFG_ACCESS_PIN
		variable ACCESS_PIN_REQ
		variable ACCESS_GRANTED
		variable CFG_ACCESS_ATTEMPTS_ALLOWED
		variable ACCESS_ATTEMPTS_ATTEMPTED

		if {$ACCESS_PIN_REQ == 1} {
			# Pin Required
			if {$ACCESS_GRANTED == 1} {
				# Access Granted - Pass commands to relay control
				changeRigState $cmd
			} else {
				# Access Not Granted Yet, Process Pin
				if {$cmd == $CFG_ACCESS_PIN} {
					set ACCESS_GRANTED 1
					printInfo "ACCESS GRANTED --------------------"
					playMsg "access_granted";
					playMsg "enter_command";
				} elseif {$cmd == ""} {
					# If only pound sign is entered, deactivate module
					deactivateModule
				} else {
					incr ACCESS_ATTEMPTS_ATTEMPTED
					printInfo "FAILED ACCESS ATTEMPT ($ACCESS_ATTEMPTS_ATTEMPTED/$CFG_ACCESS_ATTEMPTS_ALLOWED) --------------------"

					if {$ACCESS_ATTEMPTS_ATTEMPTED < $CFG_ACCESS_ATTEMPTS_ALLOWED} {
						printInfo "Please try again!!! --------------------"
						playMsg "access_invalid_pin";
						playMsg "access_try_again";
					} else {
						printInfo "ACCESS DENIED!!! --------------------"
						playMsg "access_denied";
						deactivateModule
					}
				}
			}

		} else {
			# No Pin Required - Pass straight on to relay control
			changeRigState $cmd
		}

	}

	# Executed when a DTMF command is received in idle mode. (Module Inactive)
	proc dtmfCmdReceivedWhenIdle {cmd} {
		printInfo "DTMF command received when idle: $cmd"
	}


	# Executed when the squelch opened or closed.
	proc squelchOpen {is_open} {
		if {$is_open} {set str "OPEN"} else { set str "CLOSED"}
		printInfo "The squelch is $str"
	}


	# Executed when all announcement messages has been played.
	proc allMsgsWritten {} {
		#printInfo "Test allMsgsWritten called..."
	}


# end of namespace
}
