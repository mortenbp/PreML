structure PreML :> PreML =
struct
fun run pathI pathO =
    let open Path
      val src = Source.fromString $ TextIO.readFile $ toString pathI
      val rules =
          let open Parser Rules in
            choice $ map try
                   [ doBlock
                   , openFunctor
                   , extendExisting
                   , extendNew
                   , failHere pathI src
                   , includeFile $ Path.dir pathI
                   , openFiltered
                   , listComp
                   , partTuples
                   , lazy
                   ]
          end
      val (n, src') = Rewrite.run Token.sml src rules
    in
      TextIO.writeFile (toString pathO) $ Source.toString src'
    ; n
    end
end
