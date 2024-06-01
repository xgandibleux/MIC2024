set terminal postscript eps color
set output "mogaGeneration.eps"
set key 14000, 19000 spacing 1.5
plot "Pop_0.DAT" title "Generation 0" pt 7,"Pop_10.DAT" title "Generation 10", "Pop_50.DAT" title "Generation 50" pt 1
