##トラッキング移動軌跡を模したテストデータを作成(2個体)および移動経路の描画

# 必要に応じて以下のパッケージを導入
# install.packages("maps", dependencies=T)
# install.packages("plyr", dependencies=T)
# install.packages("dplyr", dependencies=T)
# install.packages("ggplot2", dependencies=T)

library(plyr)
library(dplyr)
library(maps)


#個体１(名前:"id1")のデータを乱数から作成,データフレームdf1に格納
lon=135
lat=30
set.seed(1)#乱数の発生順(シード)を変える
x <- rnorm(100, mean=0.2, sd=0.8)
set.seed(12)#乱数の発生順(シード)を変える
y <- rnorm(100, mean=0.1, sd=0.5)
lon= cumsum(c(lon, x))
lat = cumsum(c(lat, y))
df1 <- data.frame(lon,lat, id="id01")
print(head(df1))

# df1を使って移動軌跡を地図上にプロット
# ggplot2の関数map_dataでパッケージmapsにある地図データを読み込む。
# "world"は経度0を中心とした地図。太平洋全域を（180度を越えて）
# 移動する生物の移動経路がみたい場合は"world2"を使った方がよい
mapdat <- map_data("world")

# パッケージggplot2のggplot関数でグラフを書く
# ggplotのグラフの書き方はまずベースとなるデータggplot関数で決めて
# その上にグラフフォーマット(geom_XXXXで)を上書きしていくイメージ。
# 今回は先に移動経路を書き、その上に地図を描画している
pl1 <- ggplot(df1, aes(x=lon, y=lat)) + geom_line()+　geom_point(colour="red") +
  geom_polygon(data=mapdat, aes(x=long, y=lat, group=group), fill="darkgreen", colour="black")+
  coord_fixed(xlim=c(130, 180), ylim=c(10,45))
##結果を見る
pl1
##保存したい場合は以下の通り。ファイル名の拡張子を".pdf"に代えるとpdfで保存される。
# ggsave(pl1, file="trace_id1.png")


#個体2(名前:"id2")のデータを乱数から作成,データフレームdf2に格納
lon2=135
lat2=20
set.seed(12) #乱数の発生順(シード)を変える
x <- rnorm(100, mean=0.2, sd=0.8)
set.seed(123)#乱数の発生順(シード)を変える
y <- rnorm(100, mean=-0.1, sd=0.2)

lon2= cumsum(c(lon2, x))
lat2 = cumsum(c(lat2, y))

df2 <- data.frame(lon=lon2,lat=lat2, id="id02")

#df1とdf2を結合する(dplyrのfull_join関数を使用)
df3 <- full_join(df,df2)
