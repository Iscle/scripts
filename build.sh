# Configuration
bot_id=<your_bot_id>
chat_id=<your_chat_id>
export DIR=$(pwd)/../
export CROSS_COMPILE=${DIR}/aarch64-linux-android-4.9/bin/aarch64-linux-android-
export ARCH=arm64
export SUBARCH=arm64
export DEFCONFIG=lineageos_oxygen_defconfig
export DEVICE=oxygen
export AK2=${DIR}/Ak2

# Variables to be sent
device=$device
branch=$(git branch | grep \* | cut -d ' ' -f2 | sed -r 's/ /%20/g')
commit_number=$(git rev-parse --short HEAD | sed -r 's/ /%20/g')
commit_message=$(git log -1 --pretty=%B | sed -r 's/ /%20/g')
message="$device,%20$branch,%20$commit_number:%20$commit_message"

# Start of the code
make O=out clean
make O=out mrproper
make O=out ${DEFCONFIG}
#make O=out menuconfig
make O=out -j$(nproc --all)

if [[ -f out/arch/arm64/boot/Image.gz-dtb ]]; then
	echo -e ${LGR} "\r#############################################"
	echo -e ${LGR} "\r############## Build competed! ##############"
	echo -e ${LGR} "\r#############################################"

	mv out/arch/arm64/boot/Image.gz-dtb ${AK2}/Image.gz-dtb
	cd ${AK2}
	zip -r9 "../AceKernel_Builds/AceKernel-$device-$commit_number.zip" -x README.md -- *

	curl -s -X POST https://api.telegram.org/bot$bot_id/sendMessage -d chat_id=$chat_id -d text="%F0%9F%94%9D%20New%20build%20%F0%9F%94%9D" > /dev/null
	curl -s -X POST https://api.telegram.org/bot$bot_id/sendMessage -d chat_id=$chat_id -d text="Device:%20$device" > /dev/null
	curl -s -X POST https://api.telegram.org/bot$bot_id/sendMessage -d chat_id=$chat_id -d text="Branch:%20$branch" > /dev/null
	curl -s -X POST https://api.telegram.org/bot$bot_id/sendMessage -d chat_id=$chat_id -d text="Commit:%20$commit_number:%20$commit_message" > /dev/null
	curl -s -X POST https://api.telegram.org/bot$bot_id/sendDocument -F chat_id=$chat_id -F document="@../AceKernel_Builds/AceKernel-$device-$commit_number.zip" > /dev/null
#	curl --upload-file ./AceKernel-stock.zip https://transfer.sh/AceKernel.zip
else
	echo -e ${LGR} "\r#############################################"
	echo -e ${LGR} "\r############## Build failed! ##############"
	echo -e ${LGR} "\r#############################################"
fi
