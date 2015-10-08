 #
 # Copyright � 2015, Akhil Narang "akhilnarang" <akhilnarang.1999@gmail.com>
 # Original by Varun Chitre
 # Heavily modified by Akhil :P
 # Custom build script for OwnKernel
 #
 # This software is licensed under the terms of the GNU General Public
 # License version 2, as published by the Free Software Foundation, and
 # may be copied, distributed, and modified under those terms.
 #
 # This program is distributed in the hope that it will be useful,
 # but WITHOUT ANY WARRANTY; without even the implied warranty of
 # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 # GNU General Public License for more details.
 #
 # Please maintain this if you use this script or any part of it
 #
dir=$PWD
zipdir=$dir/anykernel
device="sprout"
kernelversion="ThugLife~1.1~$(date +%Y%m%d)"
zipname="$kernelversion.zip"
START=$(date +"%s")
awesome=$(tput bold)$(tput setaf 6)
config=$device"_defconfig"
export CROSS_COMPILE="/home/akhilnarang/UBERTC/out/arm-eabi-5.2-cortex-a7/bin/arm-eabi-"
export ARCH=arm
export SUBARCH=arm
export OUT="/home/akhilnarang/android"
export OUT_DIR="/tmp/ThugLife-$device"
op=$OUT_DIR/arch/arm/boot/zImage

function cout()
{
cd $OUT
}

function croot()
{
cd $dir
}

function zip_kernel ()
{
cp $op $zipdir/tools/zImage
cd $zipdir
zip -r9 $OUT/$zipname *
cd $dir
cout
if [ -e "$zipname" ]
then
while read -p "Do you want to upload zip (y/n)? " uchoice
		do
		case "$uchoice" in
		        y|Y)
		                upload_afh $zipname
		                break
		                ;;
			      n|N )
		                break
		                ;;
		        * )
		                echo
		                echo "Invalid try again!"
		                echo
		                ;;
		esac
		done
else
echo -e "Error occurred"
echo -e "Zip not found"
fi
croot
}

function compile_kernel ()
{
echo $awesome
figlet ThugLife
echo $nocol
make $config O=$OUT_DIR
make $1 O=$OUT_DIR
END=$(date +"%s")
DIFF=$(($END - $START))
if [ -e "$op" ]
then
echo -e "$awesome ThugLife for $device Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds."
zip_kernel
else
echo -e "$awesome ThugLife $okversion for $device Build Failed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds."
fi
}

function out_tmp_clean()
{
rm -rf $OUT_DIR
mkdir -p $OUT_DIR
}
if [ ! -d "$OUT_DIR" ];
then
mkdir -p $OUT_DIR
fi
mount -t tmpfs -o size=2048M tmpfs /tmp/ThugLife-sprout
case $1 in
clean)
make clean O=$OUT_DIR
rm -f include/linux/autoconf.h
out_tmp_clean
;;
mrproper)
make mrproper O=$OUT_DIR
out_tmp_clean
;;
menu|menuconfig)
make sprout_defconfig menuconfig
;;
cleanbuild)
make clean mrproper O=$OUT_DIR
rm -f include/linux/autoconf.h
out_tmp_clean
compile_kernel -j16
;;
test|fix)
compile_kernel -j1
;;
*)
compile_kernel -j16
esac
umount /tmp/ThugLife-sprout
