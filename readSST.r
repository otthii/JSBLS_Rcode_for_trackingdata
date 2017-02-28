# 必要に応じて以下のパッケージを導入
# install.packages("maps", dependencies=T)
# install.packages("plyr", dependencies=T)
# install.packages("dplyr", dependencies=T)
# install.packages("ggplot2", dependencies=T)
# install.packages("R.utils", dependencies=T)
# install.packages("marmap", dependencies=T)
# install.packages("raster", dependencies=T)
# install.packages("ncdf4", dependencies=T)

library(maps)
library(plyr)
library(dplyr)
library(ggplot2)
library(R.utils)
library(maps)
library(marmap)
library(raster)
library(ncdf4)

year <- "2003"
id <- "304"
mm <- "10"
dd <- "31"
jet.colors <- colorRampPalette(c("#00007F", "blue", "#007FFF", "cyan", "#7FFF7F", "yellow", "#FF7F00", "red", "#7F0000"))
#wget が利用できるなら以下のコマンドでNOAAのFTPサイトから直接SSTデータをダウンロードできる
# 使えない場合はftp://podaac-ftp.jpl.nasa.gov/allData/ghrsst/data/L4/GLOB/NCDC/AVHRR_OI/2013/304/20131031-NCDC-L4LRblend-GLOB-v01-fv02_0-AVHRR_OI.nc.bz2"
# system(paste("wget -nc ftp://podaac-ftp.jpl.nasa.gov/allData/ghrsst/data/L4/GLOB/NCDC/AVHRR_OI/", year, "/", id, "/", year, mm, dd, "-NCDC-L4LRblend-GLOB-v01-fv02_0-AVHRR_OI.nc.bz2", sep=""))
# 使えない場合はブラウザなどからftp://podaac-ftp.jpl.nasa.gov/allData/ghrsst/data/L4/GLOB/NCDC/AVHRR_OI/2013/304/20131031-NCDC-L4LRblend-GLOB-v01-fv02_0-AVHRR_OI.nc.bz2"からダウンロード

# ダウンロードしたファイルは圧縮されているので解凍
bunzip2(paste(year, mm, dd, "-NCDC-L4LRblend-GLOB-v01-fv02_0-AVHRR_OI.nc.bz2", sep=""), paste(year, mm, dd, "-NCDC-L4LRblend-GLOB-v01-fv02_0-AVHRR_OI.nc", sep=""), remove=F, skip=T)
## 解凍されたファイルは専用のフォーマット(netCDF)なのだが、rastarパッケージのraster関数で直接取り込める
# 情報としては緯度経度及び付随データ(ここでは温度)の形になるが、AVHRR-OIの温度は絶対温度なので摂氏温度に補正する
sst_raster <- raster(paste(year, mm, dd, "-NCDC-L4LRblend-GLOB-v01-fv02_0-AVHRR_OI.nc", sep=""), varname="analysed_sst") -273.15
#グラフで扱いやすいようにフォーマットを変換する(rasterからSPDFへ、更にデータフレームへ)
spdf.sst <- as(sst_raster, "SpatialPixelsDataFrame")
# dplyrパッケージのrename関数でデータフレームdf.sst内の変数を改名
#"%>%"はパイプ演算子と呼ばれるもので、対象の変数名の記入を省略できる
df.sst <- as.data.frame(spdf.sst) %>% rename(analysed_sst = analysed.sea.surface.temperature)

###SSTのヒートマップを書く
pl2 <- ggplot(df.sst, aes(x=x-0.125, y=y+0.125)) + geom_raster(aes(fill=analysed_sst))+
  geom_polygon(data=mapdat, aes(x=long, y=lat,group=group)) + labs(x="Longitude", y="Latitude", fill="Temperature(C)")+
  scale_fill_gradientn(limits=c(0,35), colours=jet.colors(9)) + coord_fixed(xlim=c(130,180), ylim=c(10,45)) + theme_bw() + scale_x_continuous(expand=c(0,0))
pl2

### ヒートマップにコンターを追加
pl3 <- ggplot(df.sst, aes(x=x-0.125, y=y+0.125)) + geom_raster(aes(fill=analysed_sst)) + geom_contour(aes(z=analysed.sea.surface.temperature), colour="black", binwidth=1)
pl3 <- pl3 + geom_polygon(data=mapdat, aes(x=long, y=lat,group=group))
pl3 <- pl3 + labs(x="Longitude", y="Latitude", fill="Temperature(C)")
pl3 <- pl3 + scale_fill_gradientn(limits=c(0,35), colours=jet.colors(9)) + coord_fixed(xlim=c(130,180), ylim=c(10,45)) + theme_bw() + scale_x_continuous(expand=c(0,0))
pl3
