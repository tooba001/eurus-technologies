#create a bash menu
#!/bin/bash
echo "1.Disk space"
echo "2.Top 10 cpu consuming process"
echo "3.Top 10 memeory process"
echo "4. exit"
echo "please enter your choice"
read choice
while [ $choice  ];
do
case $choice in
1)
  echo "Disk Space"
  df -h
  ;;
2)
  echo "Top 10 Cpu process"
  ps -eo pid,comm,%cpu --sort=%cpu | head -n 11
  ;;
3)
  echo "Top 10 memory process"
  ps -eo pid,comm,%cpu --sort=%cpu | head -n 11
  ;;
4)
  exit
  ;;
*)
  echo "invalid choice"
  ;;
esac
echo "1.Disk space"
echo "2.Top 10 cpu consuming process"
echo "3.Top 10 memeory process"
echo "4. exit"
echo "please enter your choice"
read choice
done

  
  
  

