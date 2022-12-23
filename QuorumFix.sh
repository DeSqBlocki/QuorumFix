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


# Copyright 2022 DeSqBlocki 
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

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