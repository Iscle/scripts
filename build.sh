export DIR=$(pwd)
export CROSS_COMPILE=${DIR}/arm-linux-androideabi-4.9/bin/arm-linux-androideabi-
export ARCH=arm
export SUBARCH=arm
export DEFCONFIG="ace_defconfig"

export AK2=${DIR}/Ak2

make O=out ${DEFCONFIG}
make O=out -j$(nproc --all) LOCALVERSION="-BetaPhase"

mv out/arch/arm/boot/zImage ${AK2}/zImage

if [[ -f ${AK2}/zImage ]]; then
	echo -e ${LGR} "\r#############################################"
	echo -e ${LGR} "\r############## Build competed! ##############"
	echo -e ${LGR} "\r#############################################"

    cd ${AK2}
    zip -r9 "AceKernel-stock.zip" -x README.md -- *
    curl --upload-file ./AceKernel-stock.zip https://transfer.sh/AceKernel
else
    exit 0
fi
