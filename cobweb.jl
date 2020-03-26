import Printf;
using Plots;
pyplot();

function main()
# Calls the fixed point iteration.
    x0 = 0.5
    maxit = 15
    tol = 1.0e-8

    g1(x) = x^(1/3)
    g2(x) = 1/x
    g3(x) = cos(x)

    (endpt, numit, fail) = cobweb(g1, 0.5, 0.0, 1.5, 100, 1e-8, "x^(1/3)","cobweb1")
    (endpt, numit, fail) = cobweb(g2, 1.5, 0.0, 2.0, 100, 1e-8, "1/x","cobweb2")
    (endpt, numit, fail) = cobweb(g3, 0.5, 0.0, 1.5, 100, 1e-8, "cos(x)","cobweb3")

end

function cobweb(g::Function,x0::Float64,a::Float64,b::Float64,
                maxit::Int,tol::Float64,functionlabel::String,figname::String)
    #
    # DESCRIPTION :
    # Applies the fixed-point iteration to a
    # given function g and makes a cobweb plot.
    # ON ENTRY :
    # g a function in one variable
    # x0 initial guess for the fixed-point iteration
    # maxit upper bound on the number of iterations
    # tol tolerance on the abs(g(x) - x) where x is
    # the current approximation for the fixed point
    # a left bound for the range of the plot
    # b right bound for the range of the plot
    # figname name of the output .png file
    #
    # ON RETURN :
    # x the current approximation for the fixed point
    # numit the number of iterations done
    # fail true if the accuracy requirement was not met,
    # false otherwise.
    #
    # EXAMPLE :
    # g(x) = 1-x^3
    # (x, numit, fail) = fixedpoint(g,0.5,10,1.0e-4)
    r = a:0.01:b
    plot(g, r, label=functionlabel, title = "Cobweb Plot")
    ylims!((a, b))

    diagonal(x) = x
    plot!(diagonal, r, label="")

    println("running a fixed-point iteration ...")
    strit = Printf.@sprintf("%3d", 0)
    strx0 = Printf.@sprintf("%.4e", x0)
    println("$strit : $strx0")
    xprevious = x0
    xnext = xprevious

    for i=1:maxit
        xnext = g(xprevious)
        if i == 1
            plot!([xprevious], [xnext],line=(:sticks, :black), label="")
        else
            if xprevious < xnext
                plot!([xprevious], xprevious:0.01:xnext,line=(:black), label="")
            else
                plot!([xprevious], xnext:0.01:xprevious,
                line=(:black), label="")
            end
        end

        if xprevious < xnext
            plot!(xprevious:0.01:xnext, [xnext],line=(:black), label="")
        else
            plot!(xnext:0.01:xprevious, [xnext],line=(:black), label="")
        end

        strit = Printf.@sprintf("%3d", i)
        strxi = Printf.@sprintf("%.4e", xnext)
        error = abs(xnext - xprevious)
        strerr = Printf.@sprintf("%.2e", error)
        println("$strit : $strxi : $strerr" )

        if error < tol
            savefig(figname)
            return (xnext, i, false)
        end
        xprevious = xnext
    end
    savefig(figname)
    return (xnext, maxit, true)
end
