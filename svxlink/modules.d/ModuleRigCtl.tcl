####################################################################################
#  OpenRepeater RigCtl Module
#  Coded by Aaron Crawford (N3MBH), Dan Loranger(KG7PAR) & Gregg Daugherty (WB6YAZ)
#  DTMF Control of rigctl (hamlib 3.0.1) functions as defined below.
#  This example uses preset memory settings (1-8) for an IC-7100
#  rigctl -m 370 -r /dev/ttyUSB0 -s 9600 E n, where n = memory number
#  config variables are set in /etc/svxlink/ModuleRigCtl.config
#
#  When using /dev/ttyUSB0, insure permissions for /dev/ttyUSB0 are set
#  to rw for others (chmod o+rw /dev/ttyUSB0)
#
#  Usage:
#  01# = RIGCTL_1
#  02# = RIGCTL_2
#  ... etc
#
#  Visit the project at OpenRepeater.com
####################################################################################


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
			# printInfo [set CFG_RIGCTL_$n]
			# if { ([info exists CFG_RIGCTL_$n]) && ([set CFG_RIGCTL_$n] > 0) } {
				# set RIGCTL($n) [set CFG_RIGCTL_$n]
				# printInfo $RIGCTL($n)
			# }
			  set RIGCTL($n) [set CFG_RIGCTL_$n]
				printInfo $RIGCTL($n)
		    set n [expr {$n + 1}]
		}

    # printInfo $RIGCTL(1)

		# Access Variables
		variable CFG_ACCESS_PIN
		variable CFG_ACCESS_ATTEMPTS_ALLOWED
		variable ACCESS_PIN_REQ
		variable ACCESS_GRANTED
		variable ACCESS_ATTEMPTS_ATTEMPTED
	    if {[info exists CFG_ACCESS_PIN]} {
			set ACCESS_PIN_REQ 1
			if {![info exists CFG_ACCESS_ATTEMPTS_ALLOWED]} { set CFG_ACCESS_ATTEMPTS_ALLOWED 3 }
		} else {
			set ACCESS_PIN_REQ 0
		}
		set ACCESS_GRANTED 0
		set ACCESS_ATTEMPTS_ATTEMPTED 0


		printInfo "Module Activated"

		if {$ACCESS_PIN_REQ == "1"} {
			printInfo "--- PLEASE ENTER YOUR PIN FOLLOWED BY THE POUND SIGN ---"
			playMsg "access_enter_pin";

		} else {
			# No Pin Required but this is the first time the module has been run so play prompt
			playMsg "enter_command";
		}

	}


	 # Executed when this module is being deactivated.
	proc deactivateCleanup {} {
		printInfo "Module deactivated"

		variable RIGCTL_OFF_DEACTIVATION
		if {$RIGCTL_OFF_DEACTIVATION == "1"} {
			RigCtlDefault
		}
	}


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


	# Executed when a DTMF command is received
	proc changeRigState {cmd} {
		printInfo "DTMF command received: $cmd"

		variable RIGCTL

                exec python3 /usr/share/svxlink/python/set_pttlock_on.py
                printInfo "pttlock on"
                playMsg "pttlockon"

		# printInfo $RIGCTL(2)

		if {$cmd == "01"} {
		  # variable CFG_RIGCTL_1
		  # set MEM1 [set CFG_RIGCTL_1]
		  printInfo $RIGCTL(1)
		  playMsg "mem1"
                  #set pttlockon {exec python3 /usr/share/svxlink/python/set_pttlock_on.py}
                  #printInfo $pttlockon
		  #exec rigctl {*}{-m 370 -r /dev/ttyUSB0 -s 9600 E 1}
		  exec rigctl {*}$RIGCTL(1)
		  printInfo "Memory 1 selected"
		  playMsg "mem1sel"

		} elseif {$cmd == "02"} {
		    # variable CFG_RIGCTL_2
		    # set MEM2 [set CFG_RIGCTL_2]
		    printInfo $RIGCTL(2)
		    playMsg "mem2"
		    #exec rigctl {*}{-m 370 -r /dev/ttyUSB0 -s 9600 E 2}
		    exec rigctl {*}$RIGCTL(2)
		    printInfo "Memory 2 selected"
		    playMsg "mem2sel"

		} elseif {$cmd == "03"} {
		    # variable CFG_RIGCTL_3
		    # set MEM3 [set CFG_RIGCTL_3]
		    printInfo $RIGCTL(3)
		    playMsg "mem3"
		    #exec /usr/bin/rigctl {*}{-m 370 -r /dev/ttyUSB0 -s 9600 E 3}
		    exec rigctl {*}$RIGCTL(3)
		    printInfo "Memory 3 selected"
		    playMsg "mem3sel"

		} elseif {$cmd == "04"} {
		    # variable CFG_RIGCTL_4
		    # set MEM4 [set CFG_RIGCTL_4]
                    printInfo $RIGCTL(4)
		    playMsg "mem4"
		    #exec /usr/bin/rigctl {*}{-m 370 -r /dev/ttyUSB0 -s 9600 E 4}
		    exec rigctl {*}$RIGCTL(4)
		    printInfo "Memory 4 selected"
				playMsg "mem4sel"

		} elseif {$cmd == "05"} {
		    # variable CFG_RIGCTL_5
		    # set MEM5 [set CFG_RIGCTL_5]
                    printInfo $RIGCTL(5)
		    playMsg "mem5"
		    #exec /usr/bin/rigctl {*}{-m 370 -r /dev/ttyUSB0 -s 9600 E 5}
		    exec rigctl {*}$RIGCTL(5)
		    printInfo "Memory 5 selected"
		    playMsg "mem5sel"

		} elseif {$cmd == "06"} {
		    # variable CFG_RIG_CTL_6
		    # set MEM6 [set RIGCTL_6]
                    printInfo $RIGCTL(6)
		    playMsg "mem6"
		    # exec /usr/bin/rigctl {*}{-m 370 -r /dev/ttyUSB0 -s 9600 E 6}
		    exec rigctl {*}$RIGCTL(6)
		    printInfo "Memory 6 selected"
		    playMsg "mem6sel"

		} elseif {$cmd == "07"} {
		    # variable CFG_RIGCTL_7
		    # set MEM7 [set CFG_RIGCTL_7]
                    printInfo $RIGCTL(7)
		    playMsg "mem7"
		    #exec /usr/bin/rigctl {*}{-m 370 -r /dev/ttyUSB0 -s 9600 E 7}
		    exec rigctl {*}$RIGCTL(7)
		    printInfo "Memory 7 selected"
		    playMsg "mem7sel"

		} elseif {$cmd == "08"} {
		    # variable CFG_RIGCTL_8
		    # set MEM7 [set RIGCTL_8]
                    printInfo $RIGCTL(8)
		    playMsg "mem8"
		    #exec /usr/bin/rigctl {*}{-m 370 -r /dev/ttyUSB0 -s 9600 E 8}
		    exec rigctl {*}$RIGCTL(8)
                    printInfo "Memory 8 selected"
		    playMsg "mem8sel"

                } elseif {$cmd == "09"} {
                    exec python3 /usr/share/svxlink/python/set_pttlock_off.py
                    printInfo "pttlock off"
                    playMsg "pttlockoff"

		} elseif {$cmd == ""} {
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
