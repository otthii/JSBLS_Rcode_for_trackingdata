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

###移動軌跡から環境情報を抽出する自作関数
### df_locは位置情報データ、raster_objは抽出したい環境情報を示す
### ras.extはベクトルで出力される
extract.env <- function(df_loc, raster_obj){
  coordxy <- cbind(df_loc$lon, df_loc$lat)
  ras.ext <- raster::extract(raster_obj, coordxy)
  return(ras.ext)
}
#id1の移動軌跡とreadSST.rで作った表面水温データを使って移動軌跡上の水温を抽出
trace.sst <- extract.env(df1, sst_raster)

#df1に温度情報を追加する(plyrのtransform関数を使用)
df1 <- transform(df1, sst=trace.sst)

# marmapライブラリを使って海底地形図をダウンロードする
# まず、海底地形図がほしいエリアの緯度経度範囲を指定
Lon.range = c(130, 180)
Lat.range = c(10, 45)
#getNOAA.bathy関数で地形高度データを抽出(ちなみに海抜標高も出力される)
#解像度(res)は適宜調整のこと
datbat <- getNOAA.bathy(Lon.range[1],Lon.range[2],Lat.range[1],Lat.range[2],res=5)
#これもデータフォーマットが専用のものになっているのでデータフレームに変換する
tmp <- as.data.frame(as.SpatialGridDataFrame(datbat))
#　ggplotで海底地形図を描画する
# 移動軌跡データと同時に描画するのは大変なので、こちらは背景図として張り付けられるように表示を調整する。
bg <-ggplot(tmp, aes(x=s1, y=s2)) + geom_raster(aes(fill=layer),alpha=0.65) + scale_fill_gradientn(colours=c("black","white")) +
  scale_x_continuous(expand=c(0,0))+scale_y_continuous(expand=c(0,0)) + coord_fixed(xlim=c(130,180),ylim=c(10,45)) + theme_void() + guides(fill=F)

# 海底地形図込みの移動軌跡図(水温によるマーカー彩色あり)を作る
# 先ほど作った海底地形図は背景として最初に張り付け、その上に移動軌跡を書き込んでいく
tmp <- data.frame(x=c(130,180), y=c(10,45))
pl4 <- ggplot(data=tmp, aes(x=x,y=y)) + annotation_custom(ggplotGrob(bg), xmin=-Inf, xmax=Inf, ymin=-Inf, ymax=Inf) +
 geom_polygon(data=mapdat, aes(x=long, y=lat, group=group), fill="darkgreen", colour="black")
pl4 <- pl4 + geom_line(data=df, aes(x=lon,y=lat), colour="black", size=1,alpha=1) + geom_point(data=df, aes(x=lon,y=lat, colour=sst), size=2,alpha=1)
pl4 <- pl4 +  scale_color_gradientn(limits=c(10,30), colours=jet.colors(9), name="SST(C)")
pl4 <- pl4 +  coord_fixed(xlim=c(130, 180), ylim=c(10,45)) + scale_x_continuous(expand=c(0,0))+ scale_y_continuous(expand=c(0,0))
print(pl4)
