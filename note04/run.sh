#! /bin/bash

for model in linear logistic
do
    [ ! -d "./$model/output" ] && mkdir $model/output
    echo "model: $model"
    export model=$model
    for case in {1..2} # 1 2 # 5 # 
    do
        echo "case: $case"
        export case=$case
        nohup julia -t 10 run.jl > $model/output/simuCase${case}.jl &
        sleep 1s
    done
done

###############################################################################
#! /bin/bash

# # cal=1

# [ ! -d "./output" ] && mkdir output

# # echo "#! /bin/bash" > output/00combinePDF.sh
# # echo -n "pdftk " >> output/00combinePDF.sh

# for i in 1 # {1..4} # 5 # 
# do
#     echo "case: $i"
#     export case=$i
#     # if [ ${cal} == "1" ] ; then
#     nohup julia tmp.jl > output/tmp${i}.out &
#     # nohup julia -t 10 tmp.jl > output/tmp${i}.out &
#     # fi
#     # echo -n "0case${i}.pdf " >> output/00combinePDF.sh
#     sleep 0.1s
# done

# # echo "output 00mse.pdf" >> output/00combinePDF.sh
# # echo "sleep 0.1s" >> output/00combinePDF.sh
# # # echo "cp 00mse.pdf ~/Dropbox/work/Ma/revision1/figures/00mse.pdf" >> output/00combinePDF.sh
