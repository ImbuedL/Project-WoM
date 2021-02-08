#=

The output from Spectrum must start at 0x40B140 (English) and end on the
first node that has addres 0x5XXXXX

=#

function Compare(sim_filename, spectrum_filename)

  #=
  e.g.
  sim_filename = "sim_output.txt"
  spectrum_filename = "spectrum_output.txt"

  Nevermind, that'd be too easy. Instead you have to do this:

  sim_filename = joinpath(@__DIR__,"sim_output.txt")
  spectrum_filename = joinpath(@__DIR__,"spectrum_output.txt")
  =#

  # read the output from spectrum
  open(spectrum_filename, "r") do file
    spectrum_lines = readlines(file)


    global spectrum = []
    for line in spectrum_lines
      s = split(line, " ")
      address = s[1][1:6]
      type = s[2]
      if type == "LINK"
        if address[1] == '5'
          push!(spectrum, ("Node", "5FFFFF"))
        else
          push!(spectrum, ("Node", Meta.parse("0x" * address)))
        end
      elseif type == "AI"
        id = s[3][1:4]
        push!(spectrum, ("Actor", Meta.parse("0x" * address), id))
      elseif type == "AF"
        id = s[3][1:4]
        push!(spectrum, ("Overlay", Meta.parse("0x" * address), id))
      else
        println("ERROR: spectrum.txt has a line with unexpected output! [Compare() function error]")
      end
    end
  end


  # read the output from the heap sim
  open(sim_filename, "r") do file
    sim_lines = readlines(file)

    global sim = []
    for line in sim_lines
      if line[14:17] == "NODE"
        type = "Node"
        address = line[3:8]
        if address[1] == '5'
          push!(sim, ("Node", "5FFFFF"))
        else
          push!(sim, (type, Meta.parse("0x" * address)))
        end
      elseif line[23:29] == "INSTANC"
        type = "Actor"
        id = line[14:17]
        address = line[3:8]
        push!(sim, (type, Meta.parse("0x" * address), id))
      elseif line[23:29] == "OVERLAY"
        type = "Overlay"
        id = line[14:17]
        address = line[3:8]
        push!(sim, (type, Meta.parse("0x" * address), id))
      else
        println("ERROR: sim.txt has a line with unexpected output! [Compare() function error]")
      end
    end
  end

  if length(sim) == length(spectrum)
    same_length = true
  else
    same_length = false
  end

  error = false
  if same_length == false
    error = true
    sim_length = length(sim)
    spectrum_length = length(spectrum)
    println("this won't print because Atom is bad")
    println("DIFFERENCE: sim ($sim_length) and spectrum ($spectrum_length) have different lengths!")
  end

  diff_count = 0
  for i=1:min(length(sim), length(spectrum))
    if sim[i] != spectrum[i]
      error = true
      diff_count += 1
      println("-----")
      println("DIFFERENCE #$diff_count on line $i:")
      println("SPECTRUM: " * string(spectrum[i]))
      println("SIM:      " * string(sim[i]))
      println("-----")
    end
  end

  if error == false
    println("-----")
    println("SUCCESS! Both outputs match!")
  end
end

################################################################################

Compare(joinpath(@__DIR__,"sim_output.txt"), joinpath(@__DIR__, "spectrum_output.txt"))
