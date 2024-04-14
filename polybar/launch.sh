polybar-msg cmd quit

echo "---" | tee -a /tmp/polybar.log
polybar MyBar 2>&1 | tee -a /tmp/polybar.log & disown

echo "Bars launched ... " 

