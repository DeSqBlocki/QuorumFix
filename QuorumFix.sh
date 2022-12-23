LogFile=/root/quorumLog.log # writes quorum updates to Log file
GrepStatus=`pvecm status | grep "Quorate:          Yes"`
TryCounter=1 # only try a certain amount before failing
TS= date +"%Y-%m-%d_%H-%M-%S"

if [ "$GrepStatus" = "" ]; then
        # expecting "$GrepStatus" = ""; Start Script
        echo $TS": Starting QuorumFix.sh . . ."
else
        # expecting "$GrepStatus" = "Quorate:          Yes"; 
        echo $TS": Quorum Is Already Fixed! Exiting. . ."
	exit 1 # Exit with Code 1: No Need
fi

while [  "$GrepStatus" = "" ]; do
             if [ $TryCounter -gt 10]; then
             # Timout
             exit 2 # Exit with Code 2: Error
             fi
             
             # Log Progress
             echo $TS": Try No." $TryCounter >> $LogFile
             let TryCounter++
             # Try Changing Expected Value
             echo $TS": Changing Expected Votes To 1"
             /usr/bin/pvecm expected 1
             # Check Quorate And Update
             echo $TS ": Checking Quorate Again..."
             GrepStatus=`pvecm status | grep "Quorate:          Yes"`
done

echo $TS ": Quorate Fixed Successfully!" >> $LogFile
exit 0

#       Code 0 = Quorum Was Fixed Successfully!
#       Code 1 = Quorum Did Not Need To Be Fixed!
#       Code 2 = Script Couldn't Change Expected Value!

#          .  ..  ... ...... .. ...  .....  ..  .
#        .  ..  ... .....xXXX+.  -.-..... ...  ..  .
#      .   ..  ... .....xXXXX+.  -.-..... ...  ..   .
#    .   ..  ... ......xXXXX+.  . .--...... ...  ..   . 
#   .   ..  ... ......xXXXX+.    -.- -...... ...  ..   .
#  .   ..  ... ......xXXXX+.   .-+-.-.-...... ...  ..   .
#  .   ..  ... .....xXXXX+. . --xx+.-.--..... ...  ..   .
# .   ..  ... .....xXXXX+. - .-xxxx+- .-- .... ...  ..   .
#  .   ..  ... ...xXXXX+.  -.- xxxxx+ .---... ...  ..   .
#  .   ..  ... ..xXXXX+. .---.. xxxxx+-..--.. ...  ..   .
#   .   ..  ... xXXXX+. . --.... xxxxx+  -.- ...  ..   .
#    .   ..  ..xXXXX+. . .-...... xxxxx+-. --..  ..   .
#      .   .. xXXXXXXXXXXXXXXXXXXXxxxxxx+. .-- ..   .
#         .  xXXXXXXXXXXXXXXXXXXXXXxxxxxx+.  --  .
#            ..  ... ...... .. ...  .....  .  .