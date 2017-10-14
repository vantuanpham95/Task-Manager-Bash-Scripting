#!/bin/bash

#Lay cau lenh (ex: add, search,...) la tu dau tien nhap vao sau khi goi file bash
args=("$@")

#Neu dang sau cau lenh co them command thi lay command ve bien, con khong thi thoi
#Neu cu lay command ve bien luon thi khi viet dong chi co mot lenh: ./bash.sh list se gay loi
if [[ $# -gt 1 ]]; then
	cm=$(echo $* | cut -d" " -f 2-$#)
fi


#Get the file name of this bash scripts file
me=`basename "$0"`
#echo $me

#Get the full file path of this bash scripts file
#echo $(readlink -f "$me")

#Get the dir of this bash scripts file and then make the full file path of textfile
ck=$(echo $(dirname $(readlink -f "$me"))"/task_manager.txt")
#echo $ck

#touch this file, so if the file is exist, touch command will do nothing else touch command will make create; 
#Neu file txt khong ton tai ma da co cau lenh search luon thi se bi loi
touch $ck

function add(){
	echo $cm > task_undone.temp
	nl -s "<undone>" task_undone.temp >> task_manager.txt
	rm -rf task_undone.temp
	
	#remove duplicate task
	awk '!a[$0]++' task_manager.txt > task_manager.temp
	mv task_manager.temp task_manager.txt
}



function list(){
	echo "Undone"
	cat task_manager.txt | grep "<undone>" | awk -F'<undone>' '{print $2}' > task_undone.temp
	nl task_undone.temp
	rm -rf task_undone.temp
	
	echo ""
	echo "Low priority"
	cat task_manager.txt | grep "<low_prioriry>"| awk -F'<low_prioriry>' '{print $2}' > task_low_priority.temp
	nl task_low_priority.temp
	rm -rf task_low_priority.temp
	
	echo ""
	echo "Done"
	cat task_manager.txt | grep "<done>"| awk -F'<done>' '{print $2}' > task_done.temp
	nl task_done.temp
	rm -rf task_done.temp

}


function search(){
	echo "Here is your search: "
	echo "Undone"
	cat task_manager.txt | grep "$cm" | grep "<undone>" | awk -F'<undone>' '{print $2}' > task_undone.temp
	nl task_undone.temp
	rm -rf task_undone.temp

	echo ""
	echo "Low priority"
	cat task_manager.txt | grep "$cm" | grep "<low_prioriry>"| awk -F'<low_prioriry>' '{print $2}' > task_low_priority.temp
	nl task_low_priority.temp
	rm -rf task_low_priority.temp
	
	echo ""
	echo "Done"
	cat task_manager.txt | grep "$cm" | grep "<done>"| awk -F'<done>' '{print $2}' > task_done.temp
	nl task_done.temp
	rm -rf task_done.temp
}


function clean(){
	> task_manager.txt
	echo "Removed all tasks!"
}

function remove(){
	# sed '/$cm/d' task_manager.txt
	# awk '!/$cm/' task_manager.txt > task_manager.temp
	# loc cac dong khong co $cm
	# grep -ivw: loc khong phan biet chu hoa, chu thuong, loc ngoai le, loc dung tu, khong loc sub-string
	cat task_manager.txt | grep -iwv "$cm" > task_manager.temp
	mv task_manager.temp task_manager.txt
	echo "Removed all lines exactly containing string: $cm "
}

function markdone(){
	#Luu cac task khong lien quan ra file khac
	cat task_manager.txt | grep -iwv "$cm" > task_manager.temp

	#Luu cac task duoc mark done sang mot file khac chi gom ten task
	cat task_manager.txt | grep -iw "$cm" | awk -F'<undone>' '{print $2}' > task_done.temp
	cat task_manager.txt | grep -iw "$cm" | awk -F'<low_prioriry>' '{print $2}' >> task_done.temp

	#Danh dau cac task done co prefix la <done>
	nl -s "<done>" task_done.temp > make_done.temp

	#Hop nhat cac task mark done va cac task khong lien quan lai lam mot
	mv task_manager.temp task_manager.txt
	cat make_done.temp >> task_manager.txt

	#Xoa cac file tam da tao ra
	rm -rf task_done.temp
	rm -rf make_done.temp


	echo "Mark task $cm as done successfully!"
}

function setlowpriority(){
	#Luu cac task khong lien quan ra file khac
	cat task_manager.txt | grep -iwv "$cm" > task_manager.temp

	#Luu cac task duoc mark low priority sang mot file khac chi gom ten task
	cat task_manager.txt | grep -iw "$cm" | awk -F'<undone>' '{print $2}' > task_low_priority.temp

	#Danh dau cac task low priority co prefix la <low_priority>
	nl -s "<low_prioriry>" task_low_priority.temp > make_low_priority.temp

	#Hop nhat cac task mark low priority va cac task khong lien quan lai lam mot
	mv task_manager.temp task_manager.txt
	cat make_low_priority.temp >> task_manager.txt

	#Xoa cac file tam da tao ra
	rm -rf task_low_priority.temp
	rm -rf make_low_priority.temp

	
	echo "Mark task $cm as low priority successfully!"
}

function mod(){
	if [[ $cm ]]; then
		#echo $cm
		cm1=$(echo $cm | awk -F' @ ' '{print $1}')
		#echo $cm1

		cm2=$(echo $cm | awk -F' @ ' '{print $2}')
		#echo $cm2
		cat task_manager.txt | grep -iwv "$cm1" > task_manager.temp
		#cat task_manager.temp
		#echo ""


		cat task_manager.txt | grep -iw "$cm1" > task_mod.temp
		#cat task_mod.temp
		#echo ""

		#sed -i 's/$cm1/$cm2/' task_mod.temp
		sed -i "s/$cm1/$cm2/" task_mod.temp
		
		mv task_manager.temp task_manager.txt
		cat task_mod.temp >> task_manager.txt

		rm -rf task_mod.temp

		echo "Modified!"

	else
		read -r -p "Nhap vao chuoi can thay: " cm1
		read -r -p "Nhap vao chuoi thay the: " cm2
		
		cat task_manager.txt | grep -iwv "$cm1" > task_manager.temp
		cat task_manager.txt | grep -iw "$cm1" > task_mod.temp

		sed -i "s/$cm1/$cm2/" task_mod.temp

		mv task_manager.temp task_manager.txt
		cat task_mod.temp >> task_manager.txt

		rm -rf task_mod.temp

		echo "Modified!"
	fi
}


$args
