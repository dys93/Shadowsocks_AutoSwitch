#/bin/bash
template="{\n
	\"server\":\"target_server\",\n
	\"server_port\":8989,\n
	\"local_address\":\"127.0.0.1\",\n
	\"local_port\":1080,\n
	\"password\":\"helloworld!\",\n
	\"timeout\":300,\n
	\"method\":\"aes-256-cfb\",\n
	\"fast_open\":false,\n
	\"workers\":1\n
}"
#echo -e $template
#echo -e ${template/target_server/"baidu.com"}
str="192.168.1.1"
servers=(
"acm.tongji.edu.cn"
"acm.tongji.edu.cn"
"acm.tongji.edu.cn"
"acm.tongji.edu.cn"
)
test_int=(3.4 5.8 334 98 1.32)
func_get_avg_ping_time(){ #need a varibale the ip given by user
	command="ping -q -c 5 $1"
	message=`eval $command`
	message=${message#*=*/}
	message=${message%%/*}
	echo $message
}
#get avg ping time 
#time=$(func_get_avg_ping_time "acm.tongji.edu.cn")
#echo "ping avg time to acm.tongji=$time"

func_get_min_num(){ #两个数字取小输出
	if [ $(echo "$1 > $2" | bc) -eq 1 ]; 
	then
		echo $2
	else  
		echo $1	
	fi
}

#echo $(func_get_min_num 4 3.4)


func_get_index_of_min_num(){ #获得array中最小值的索引位置
	array=(`echo "$@"`)
	num=${#array[@]}
	index=0
	min=${array[0]}
	i=0
	#echo $num
	while(($i<$num))
	do
		if [ $(echo "$min > ${array[$i]}" | bc) -eq 1 ]; 
		then
			#echo "最小改变$min ->${array[$i]}"        		
			min=${array[$i]}
			index=$i
		fi
		let "i++"
	done
	echo $index
}
#echo $(func_get_index_of_min_num ${test_int[*]})

func_get_min_ping(){ #需要输入array-ip  ;返回avg_time 最小的server
	array=(`echo "$@"`)
	num=${#array[@]}
	i=0
	string=$(
	while(($i<$num))
	do
		(
		#echo $(func_get_avg_ping_time ${array[$i]})
		echo "$i $(func_get_avg_ping_time ${array[$i]})"
		)&	#后台并行处理 速度快
		let "i++"
	done
	wait   #等待并行结果出来
	)

	#处理并行的结果
	string=($string)   #自动转化为数组

	for i in $(seq 0 2 $((num*2)));do    
		index[$((i/2))]=${string[$i]}
	done

	for i in $(seq 1 2 $((num*2)));do
		time[$((i/2))]=${string[$i]}
	done
	#echo "time=${time[*]}"

	minindex=$(func_get_index_of_min_num ${time[*]})
	
	#echo "minindex = $minindex"
	#echo "realindex= ${index[$minindex]}"
	#echo "all time = ${timearray[*]}"

	echo ${array[${index[$minindex]}]}
}
#echo ${test_int[*]}
# 获得我们要的最快的那个ping的server
#(func_get_min_ping ${servers[*]}) 

#用最快的ping-server 替换template 中的目标子段
answer=${template/"target_server"/$(func_get_min_ping ${servers[*]})} 

echo -e $answer

#将答案写入文件 任务完成
echo -e $answer > answer.txt




func_list(){
	array_input=(`echo "$@"`)
	num=${#array_input[@]}
	echo "数组数量=$num"
	echo "func_list2=${array_input[2]}"
}

#func_list ${servers[*]}

numbers=(
312
54235
534
324
64
1
)
#echo "第4个数字是 ${numbers[3]}"

#sed -e "s/\"server\":\".*\"/\"server\":\"${str}\"/" config.json
#echo ${servers[0]}


minn=1000000
for number in "${numbers[@]}"
do
	if test $[number] -lt $[minn]
	then
		minn=$number
	fi
done



#获得第二个数字
message="aa=100/100.03/8384.9"
message=${message#*=*/}
message=${message%%/*}

#因为是弱类型所以不需要转换string到float。。
big=100.1
small=$message
#if [ $(echo "$big > $small" | bc) -eq 1 ]; then
        #echo "$big is bigger than $small"
#fi

