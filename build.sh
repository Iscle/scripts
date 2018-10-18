export DIR=$(pwd)/../
export CROSS_COMPILE=${DIR}/aarch64-linux-android-4.9/bin/aarch64-linux-android-
export ARCH=arm64
export SUBARCH=arm64
export DEFCONFIG="lineageos_oxygen_defconfig"

export AK2=${DIR}/Ak2

make O=out clean
make O=out mrproper
make O=out ${DEFCONFIG}
make O=out -j$(nproc --all)

mv out/arch/arm64/boot/Image.gz-dtb ${AK2}/Image.gz-dtb

if [[ -f ${AK2}/Image.gz-dtb ]]; then
	echo -e ${LGR} "\r#############################################"
	echo -e ${LGR} "\r############## Build competed! ##############"
	echo -e ${LGR} "\r#############################################"

	cd ${AK2}
	zip -r9 "AceKernel-stock.zip" -x README.md -- *
	curl --upload-file ./AceKernel-stock.zip https://transfer.sh/AceKernel.zip
else
	echo -e ${LGR} "\r#############################################"
        echo -e ${LGR} "\r############## Build failed! ##############"
        echo -e ${LGR} "\r#############################################"
fi
