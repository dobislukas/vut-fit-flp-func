#FORD-FULKERSON
#xdobis01
#Lukas Dobis
#FLP 2021

build:
	ghc -dynamic -o ford-fulkerson --make ./src/*.hs

run: 
	echo " "; ./ford-fulkerson -f ./test/test01.in
	
reset:
	rm -f ford-fulkerson ./src/*.hi ./src/*.o ./test/*.out

clean:
	rm -f ./src/*.hi ./src/*.o ./test/*.out
		
tests:
	./ford-fulkerson -i -v -f ./test/test01.in > ./test/test01_all.out
	./ford-fulkerson -i -v -f < ./test/test01.in > ./test/test01_stdin.out
	./ford-fulkerson -i ./test/test01.in > ./test/test01_i.out
	./ford-fulkerson -v ./test/test01.in > ./test/test01_v.out
	./ford-fulkerson -f ./test/test01.in > ./test/test01_f.out
	./ford-fulkerson -f ./test/test01.in -v -i > ./test/test01_order.out
	-./ford-fulkerson -i -a ./test/test01.in 2> ./test/test01_badFlag.out
	./ford-fulkerson -i -v -f ./test/test02.in > ./test/test02_all.out
	./ford-fulkerson -i -v -f ./test/test03.in > ./test/test03_all.out
	./ford-fulkerson -i -v -f ./test/test04.in > ./test/test04_all.out
	./ford-fulkerson -i -v -f ./test/test05.in > ./test/test05_all.out
