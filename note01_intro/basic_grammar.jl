#' # Julia Basic

#' ## Some useful commands in Julia REPL:

#' - ? (enters help mode);
#' - ; (enters system shell mode);
#' - ] (enters package manager mode);
#' - Ctrl-c (interrupts computations);
#' - Ctrl-d (exits Julia);
#' - Ctrl-l clears screen;
# - putting `;` after the expression disables showing its value in REPL.

#' ## Examples of some essential functions:
#' Get current working directory
pwd()

#' Change directory with Mac and Linux
cd("/home/ossifragus/Dropbox/teaching/julia/note01_intro")

#' For Windows, use this format:
#+ eval=false
cd("C:\\Users\\hwzq7\\Dropbox\\teaching\\julia\\note01_intro")

#' Execute source file
include("pi.jl") 
#+ eval=false
include("heart.jl") 
#' More information about this code [here](https://github.com/maxbennedich/code-golf/tree/cea06287689868f2342959f9c12f0b629a1d0cf4/hearts).

#' Exit Julia
#+ eval=false
exit()

#' ## String operations:
s = "abdαβΣρχρ"         # a string of type String
s[1:3]                  # first three characters
SubString(s, 2, 4)      # characters from 2 to 6
s[1]                    # first character
s[[1]]                  # first character as a SubString
"Hi " * "there!"        # string concatenation
"Ho " ^ 3               # repeat string
string("a = ", 123.3)   # create using print function
occursin("CD", "ABCD")  # check if the second string contains the first
x = 123
s = "$x + 3 = $(x+3)"   # unescaped $ is used for interpolation
chop(s, head=1, tail=2) # remove first and last two characters

#' More on strings: https://docs.julialang.org/en/v1/manual/strings/

#' ## Vectors, Matrices, and higher-dimensional arrays
#' Define a vector
x = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
#' Use `.` to broadcast. For example 
y = log.(x)

#' Define a matrix
xx = [1 2 3;
      4 5 6;
      7 8 9]

xx = [1; 2; 3;;
      4; 5; 6;;
      7; 8; 9]

#' Define three-dimensional array
xxx = [xx;;; 2xx;;; 3xx]

#' Transpose of xx. Note that there is no data copying here: 
#' if you change `xx`, then `xxp` also changes.

xxp = xx'

#' Construct a 10 by 2 matrix, with columns x and y combine by columns
mat = hcat(x, y)
mat = [x y]
mat = [x;; y]

#' Combine by rows
vcat(xx, xxp)
[xx; xxp]

#' The following will create an array of arrays with length 2
a = [x, y]

#' Elements of an array can be of any type
tmp = [3, x, 'a', "🍎🎅"]

#' Check the dimensions
size(mat)      # The number of rows and columns of a matrix
size(mat, 2)   # The number of columns of a matrix
size(mat, 1)   # The number of rows of a matrix
size(xxx)

#' Indexing
mat[3, 2]     # Value in the third row and the second column of mat
mat[3:3, 2]   # Vector with the third row and the second column of mat 
mat[3:3, 2:2] # Matrix with the third row and the second column of mat  
mat[1:3, :]   # The first three rows of mat
mat[1:11, ]   # The first eleven rows of mat as a vector
mat[:, 2]     # The second column of mat

mat[1:end .!= 2, :]            # Exclude the second row
mat[1:end .∉ 2, :]             # Exclude the second row
mat[1:end .∉ [[2, 4]], :]      # Exclude the second and the fourth rows
mat[setdiff(1:end, [2, 4]), :] # Exclude the second and the fourth rows

#' More on `setdiff`
setdiff(1:8, [3, 5])
setdiff([1, 3, "true", 't'], "true")   # 't' will be removed
setdiff([1, 3, "true", 't'], ["true"]) # "true" will be removed

#' The function view does not make copy of the elements of dat,
#' but dat[1:5, :] create a new matrix.
dat1 = mat[1:5, 1:2]
dat2 = view(mat, 1:5, 1:2)

dat1[1,1] = -1; mat
dat2[1,1] = -1; mat

#' ## Arithmetics and simple functions
x .+ y
z = x .- y
x .* y

2x
x .^ 2
2 .^ x
Int128(2).^x

a = ones(2, 3)
b = collect(1:3)
a' .* b   # elementwise multiplication
a * b     # matrix multiplication

sum(mat)         # Summation of all the elements in x
sum(mat, dims=1) # Summation of all the elements in x by columns
sum(mat, dims=2) # Summation of all the elements in x by rows

#' ## Logic Operations
sum(x) > 10                   # if sum of x is greater than 10
2 > 3 || 6 < 7                # if 2 > 3 or 6 < 7
true || println("hello")   # if true, do not print "hello"
false || println("hello")  # if false, print "hello"
true && println("hello")   # if true, print "hello"
false && println("hello")  # if false, do not print "hello"

#' returns 1 if true and 0 if false
x[1] > 1000 ? 1 : 0

#' another example
a = 1
a > 10 ? println("hello") : println("Hi")

#' There are standard programming constructs:
if false    # if clause requires Bool test
    🍎 = 1
elseif 1 == 2
    🍑 = 2
else
    💔 = 3
end        # after this 💔 = 3, and 🍎 and 🍑 are undefined

#' As showed above, Julia support unicode characters. 
#' Greek letters can be input like LaTeX, e.g., 
α = 0.05
β = 0.8
α̂ = 0.3

#' See this link for a list of tab completion of LaTeX style input:
#' https://docs.julialang.org/en/v1/manual/unicode-input/

#' ## Loops
x = 1:10
s = 0
for i in 1:length(x)
    global
    s += x[i]
end
s

i = 1
while true
    global i += 1
    if i > 10
        break
    end
end

for x in 1:10    # x in collection, can also use = here instead of in
    if 3 < x < 6
        continue # skip one iteration
    end
    println(x)
end              # x is defined in the inner scope of the loop

#' Create arrays using for loop
[x^2 for x in 1:5]
[i+j for i in 1:3, j in 2:6]

ρ, p = 0.6, 7
[ρ^abs(i-j) for i in 1:p, j in 1:p]
#' Of course, there are other ways to create arrays
ρ.^abs.((1:p) .- (1:p)')

#' ## Self-defined functions
function fsum(x)
    s = 0
    for i in x
        s += i
    end
    return s
end
fsum(x)

f(x, y = 10) = x .+ y # one line definition of a new function

function f(x, y=10) # the same as above
    x .+ y
end

#' ## Measure performance with `@time` and pay attention to memory allocation
#' A useful tool for measuring performance is the `@time`.
x = rand(1000);
function sum_global()
    s = 0.0
    for i in x
        s += i
    end
    return s
end;

@time sum_global()

@time sum_global()

#' On the first call (`@time sum_global()`) the function gets compiled. (If you've not yet used `@time`
#' in this session, it will also compile functions needed for timing.)  You should not take the results
#' of this run seriously. For the second run, note that in addition to reporting the time, it also
#' indicated that a significant amount of memory was allocated. We are here just computing a sum over all elements in
#' a vector of 64-bit floats so there should be no need to allocate memory (at least not on the heap which is what `@time` reports).

#' Unexpected memory allocation is almost always a sign of some problem with your code, usually a
#' problem with type-stability or creating many small temporary arrays.
#' Consequently, in addition to the allocation itself, it's very likely
#' that the code generated for your function is far from optimal. Take such indications seriously
#' and follow the advice below.
#' 
#' If we instead pass `x` as an argument to the function it no longer allocates memory
#' (the allocation reported below is due to running the `@time` macro in global scope)
#' and is significantly faster after the first call:

function sum_arg(x)
    s = 0.0
    for i in x
        s += i
    end
    return s
end;

@time sum_arg(x)

@time sum_global()
@time sum_arg(x)

#' The 1 allocation seen is from running the `@time` macro itself in global scope. If we instead run
#' the timing in a function, we can see that indeed no allocations are performed:

time_sum(x) = @time sum_arg(x);

time_sum(x)

#' For more serious benchmarking, consider the [BenchmarkTools.jl](https://github.com/JuliaCI/BenchmarkTools.jl)
#' package which among other things evaluates the function multiple times in order to reduce noise.

#' See https://docs.julialang.org/en/v1/manual/performance-tips/ for more performance tips. 

#' As an additional example, calculate

#' $S=\sum_{i=1}^p\sum_{j=1}^p\rho^{|i-j|},$
#' for $\rho=0.5$, $p=1000$.
ρ, p = 0.5, 10000
@time S = sum([ρ^abs(i-j) for i in 1:p, j in 1:p])
@time S = sum(ρ.^abs.(1(1:p) .- (1:p)'))

function findS(ρ, p)
    S = 0.0
    for i in 1:p, j in 1:p
        S += ρ^abs(i-j)
    end
    return S
end

@time findS(ρ, p)
