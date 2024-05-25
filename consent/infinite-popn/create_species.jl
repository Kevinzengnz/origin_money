"""
Creates all species in the two strategy space and writes them to a file.
"""


function makeAllSpeciesOriginal(FULL_STRATEGY_SPACE=true)
    # make ALL species!!
    # Returns them as a SortedDict, with the name as key.
    #allspecies = OrderedDict{String,Any}()
    allspecies = Dict{String,Any}()
    ScoreChgOptions  = "-0+" 
    HelpOfferOptions = "g0r"
        
    for selfChg_NeedS0 in ScoreChgOptions
        for help_NeedS0 in HelpOfferOptions
            for otherChg_NeedS0 in ScoreChgOptions
                for selfChg_SurpS0 in ScoreChgOptions
                    for help_SurpS0 in HelpOfferOptions
                        for otherChg_SurpS0 in ScoreChgOptions
                            for selfChg_NeedS1 in ScoreChgOptions# [selfChg_NeedS0]#ScoreChgOptions
                                for help_NeedS1 in HelpOfferOptions#[help_NeedS0]#HelpOfferOptions
                                    for otherChg_NeedS1 in ScoreChgOptions# [otherChg_NeedS0]#ScoreChgOptions
                                        for selfChg_SurpS1 in ScoreChgOptions# [selfChg_SurpS0]#ScoreChgOptions
                                            for help_SurpS1 in HelpOfferOptions#[help_SurpS0]#HelpOfferOptions
                                                for otherChg_SurpS1 in ScoreChgOptions# [otherChg_SurpS0]#ScoreChgOptions

                                                    # We don't need to include strategies that would be == "no offer"
                                                    # in effect, due to being unrealisable in practice.
                                                    # (nb: no problem to include them, but makes interpretation harder due to 
                                                    # effective redundancy among the possible strategies.)
                                                    # NOTICE this excludes "money" -r+,+g-  from the full strategy space.
                                                    
                                                    """
                                                    if  (FULL_STRATEGY_SPACE) && # nb. this needed, else will 
                                                                                 # exclude (eg) money from the restricted space too! 
                                                        ((selfChg_NeedS0 == '-') || (selfChg_SurpS0 == '-')) #
                                                        continue # because, even if agreed to, this would reduce x score below zero
                                                    elseif (help_NeedS0 == 'g') || (help_NeedS1 == 'g')
                                                        continue # because x can't give if it is in need.
                                                    end
                                                    """
                                                    if (help_NeedS0 == 'g') || (help_NeedS1 == 'g')
                                                        continue # because x can't give if it is in need.
                                                    end
                                                    if ((selfChg_NeedS0 == '-') || (selfChg_SurpS0 == '-'))
                                                        continue # because the score can't go negative.
                                                    end
                                                    
                                                    species = Dict{String,Any}()
                                                    species["strategy"]= Dict{String,Any}()
                                                    # prep the STRINGS that go into the offer dictionaries.
                                                    dumS0 = selfChg_NeedS0 * help_NeedS0 * otherChg_NeedS0 
                                                    dumS1 = selfChg_NeedS1 * help_NeedS1 * otherChg_NeedS1
                                                    species["strategy"]["need"] = Dict([("S0",dumS0),("S1",dumS1)])
                                                    dumS0 = selfChg_SurpS0 * help_SurpS0 * otherChg_SurpS0
                                                    dumS1 = selfChg_SurpS1 * help_SurpS1 * otherChg_SurpS1
                                                    species["strategy"]["surp"] = Dict([("S0",dumS0),("S1",dumS1)])
                                                    species["name"] = strategy2name(species) # knows its own name

                                                    if FULL_STRATEGY_SPACE || isZeroSum(species["name"])
                                                        allspecies[species["name"]] = species # name is its key in allspecies
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    println(length(allspecies)," species altogether")
    for (name,spec) in collect(allspecies)[1:6]
       println(name)
    end
    return(allspecies)
end

#------------------------------------------------------------------------------------------------------------
"""
Take a species (essentially, a dictionary of offers) and generate a single string that represents it.
"""
function strategy2name(species)
    S0name = species["strategy"]["need"]["S0"] * ',' * species["strategy"]["surp"]["S0"]
    S1name = species["strategy"]["need"]["S1"] * ',' * species["strategy"]["surp"]["S1"]

    #if S1name == S0name
    #    return( S0name )
    #else
    #    return( S0name * "|" * S1name )
    #end
    return( S0name * "|" * S1name )
end


FULL_STRATEGY_SPACE = true #nb: set "false" if you ONLY want the score-conserving strategies.
allspecies = makeAllSpeciesOriginal(FULL_STRATEGY_SPACE) 

fname="SpeciesList.txt"
open(fname, "w") do file
    for (species_name, species_strategies) in allspecies
        write(file, species_name * "\n")
    end
    
end
#loop through allSpecies and writes each to a file
