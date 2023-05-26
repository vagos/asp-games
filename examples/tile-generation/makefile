OUT = out

$(OUT)/map.png: $(OUT)/map.txt
	convert $(OUT)/map.txt $(OUT)/map.png

$(OUT)/map.txt: main.py main.pl
	mkdir -p out
	python main.py > $(OUT)/map.txt
