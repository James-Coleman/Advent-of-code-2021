import Foundation

var greeting = "Hello, playground"

enum Error: Swift.Error {
    case unexpectedCharacter(Character)
}

enum ChunkResult {
    case complete
    case incomplete(requires: [Character])
    case corrupted(expected: Character?, found: Character)
}

func chunkChecker(_ input: String) throws -> ChunkResult {
    var parenCount = 0
    var squareCount = 0
    var curlyCount = 0
    var angleCount = 0
    
    var openers = [Character]()
    
    let matchingPairs: [Character?: Character] = ["(": ")",
                                                  "[": "]",
                                                  "{": "}",
                                                  "<": ">"]
    
    for character in input {
        switch character {
            case "(":
                parenCount += 1
                openers.append("(")
            case "[":
                squareCount += 1
                openers.append("[")
            case "{":
                curlyCount += 1
                openers.append("{")
            case "<":
                angleCount += 1
                openers.append("<")
            case ")":
                parenCount -= 1
                guard let lastOpener = openers.last, lastOpener == "(" else { return .corrupted(expected: matchingPairs[openers.last], found: character) }
                openers.popLast()
            case "]":
                squareCount -= 1
                guard let lastOpener = openers.last, lastOpener == "[" else { return .corrupted(expected: matchingPairs[openers.last], found: character) }
                openers.popLast()
            case "}":
                curlyCount -= 1
                guard let lastOpener = openers.last, lastOpener == "{" else { return .corrupted(expected: matchingPairs[openers.last], found: character) }
                openers.popLast()
            case ">":
                angleCount -= 1
                guard let lastOpener = openers.last, lastOpener == "<" else { return .corrupted(expected: matchingPairs[openers.last], found: character) }
                openers.popLast()
            default:
                throw Error.unexpectedCharacter(character)
        }
        
        guard parenCount >= 0, squareCount >= 0, curlyCount >= 0, angleCount >= 0 else { return .corrupted(expected: "?", found: "?") } // We should never hit this
    }
    
    if parenCount == 0 && squareCount == 0 && curlyCount == 0 && angleCount == 0 {
        return .complete
    } else {
        return .incomplete(requires: openers.reversed().compactMap { matchingPairs[$0] })
    }
}

do {
//    try chunkChecker("()")
//    try chunkChecker("[]")
//    try chunkChecker("([])")
//    try chunkChecker("{()()()}")
//    try chunkChecker("<([{}])>")
//    try chunkChecker("[<>({}){}[([])<>]]")
//    try chunkChecker("(((((((((())))))))))")
//
//    try chunkChecker("(]")
//    try chunkChecker("{()()()>")
//    try chunkChecker("(((()))}")
//    try chunkChecker("<([]){()}[{}])")
} catch {
    error
}

let exampleInput = """
    [({(<(())[]>[[{[]{<()<>>
    [(()[<>])]({[<{<<[]>>(
    {([(<{}[<>[]}>{[]{[(<()>
    (((({<>}<{<{<>}{[]{[]{}
    [[<[([]))<([[{}[[()]]]
    [{[{({}]{}}([{[{{{}}([]
    {<[[]]>}<{[{[{[]{()[[[]
    [<(<(<(<{}))><([]([]()
    <{([([[(<>()){}]>(<<{{
    <{([{{}}[<[[[<>{}]]]>[]]
    """

do {
//    for line in exampleInput.components(separatedBy: .newlines) {
//        print(line, try chunkChecker(line))
//    }
} catch {
    error
}

do {
//    try chunkChecker("{([(<{}[<>[]}>{[]{[(<()>") // correctly says corrupted
//    try chunkChecker("[[<[([]))<([[{}[[()]]]") // correctly says corrupted
//    try chunkChecker("[{[{({}]{}}([{[{{{}}([]") // correctly says corrupted
//    try chunkChecker("[<(<(<(<{}))><([]([]()") // correctly says corrupted
//    try chunkChecker("<{([([[(<>()){}]>(<<{{") // correctly says corrupted
} catch {
    error
}

func corruptedScore(for input: String) throws -> Int {
    try input.components(separatedBy: .newlines).reduce(0) { (soFar, line) in
        let result = try chunkChecker(line)
        
        if case let .corrupted(_, found) = result {
            switch found {
                case ")": return soFar + 3
                case "]": return soFar + 57
                case "}": return soFar + 1197
                case ">": return soFar + 25137
                default: throw Error.unexpectedCharacter(found)
            }
        } else {
            return soFar
        }
    }
}

do {
//    try corruptedScore(for: exampleInput) // 26397 (correct)
} catch {
    error
}

let puzzleInput = """
    <{[[({([{<[[([()<>]<<><>>)<[[]()]{<>()}>][<(()[])<()<>>>]]<(<(<><>)(())>)[<([]()){<><>}>{{()<>}<{}>}]>>[({
    <<({<{{{[(<{([{}{}]{{}[]}){({}())}}<<[[][]](()<>)>[{<><>}<{}<>>]>>(<[[()]([]{})]((()<>)[()()
    ({<<({[<[[<[([()])]<<<{}<>><()[]>>[[()<>]<[]()>]>>([((()[])[()])]{[[()()]<<><>>][{<>[]}(()<>)]})
    (([[<<[{(({{{(()<>)[()()]}[({}<>)[[][]]]}([{{}<>}<[]()}]{[[][]][()<>]})})(([({[]{}}{[][]})
    ({{<[[<<{{[{[<{}{}>{[]{}}]<([]{}){()[]}>}]<{([<><>]([]<>)){({}())({}<>)}}[[<{}<>>([]{})][[()[]]]]>}}>>]]
    [(<<<{([[[<{(<()<>>{<><>})(<[]<>>([][]))}[<[{}[]]>{<[]>(<><>)}]>([{{[]()}{[]()}}([<>[]][{}<>
    <[{[{{([<(<{{[{}<>]({}{})}{{<>[]}(()())}}(<<<>{}>(<><>)>(<<>{}>[[]<>]))>)>[{[<[[()<>]{{}<>
    {(<<[([<{<<<({()()}(<><>)}{((){})([]())}>>[<{<[]<>>{[]{}}}([()()])>]>}>]{{([{<{{[]<>}(<>)}<({}(
    ((<[{(({([<{(<[][]>)[<<>{}><()<>>]}<{<{}{}>}[{()[]}<{}[]>]>>])})<[{[{([{[]()}((){})][<<>()><()()>])>]}][[({{[
    [[{([[<<[({[<<[]{}>{[][]}>(<()<>>[{}()])][([{}[]}[<><>]){[{}()]}]}[<<<{}<>>{()<>}>(<{}()>([]()))>{[[<><>][
    {{{<[([[{<[<{([]{}>{<>()}}{<(){}><()()>}>[{[[][]](<>())}[{[]<>}[<>[]]]]]{<{{{}[]}{<><>}}[[()()](<
    (([{(({[[[[{(<<>[]>((){})){<()<>><[]{}>}}{[{{}()}(()[])]((()){()<>})}]]]<[<<{(()[])<{}[]>}{
    {<<([(<([{{(<(()<>)[[][]]>{[[]{}]{(){}}})[{<(){}>[[]<>]}]}}])[[[([[{()()}{<>[]}]{[()]{[][]}}]<[((
    [{<<{<([(<[<{<{}[]>{{}[]}}(([]()))>{([(){}]<()[]>)(<[][]>{[]<>})}]>[{<<{<>()}[{}[]]>{(<><>)}>{[<[]<>>{()[]}]<
    <{{<{[[{{([({<()>{(){}}}((<>[])(<><>)))[(<[]<>>[()[]])<<()()>{<>{}}>]])<[{[{[]<>}{()()}][[{}{}]<[]>]}<{{{
    [(<[{([{({<<[<<>()>[[]()]]{<<>{}><{}<>>}><{<()()>{{}{}}}(({}<>)<()<>>)>>})({(([<{}<>>{[][]
    {(([{[<{{[({{[{}<>][()]}<{{}<>}>}(({<>[]})))]{((<[<>{}][<>[])>[[<>()]{[][]}]))<<<({}<>){{}<>}>(
    {[<{({((([[{[(<>{}){<>()}][([]{}}]}]{[<(()()){[]()}>((<>[])<(){}>)]}]){<(<<{{}<>}>>)([[{<><>}<
    {<{[(<{<[({<<[<><>]{()()}>[{()<>}<{}>]>[[<[]>][{()[]}{()}]]}(<(({}()){<><>})<(()())[<>()]>>{
    <[({[[{<([[{<{{}}>(<<><>>{[]()}}}[{{<>{}}<()<>>}{[[][]]{[]<>}}]]<((([][])<<>{}>)<((){})[{}()
    {{[{<[{<<{<<(<{}[]><(){}>)<{<>[]}[{}()]>>[{{[]<>}<()<>>}[{{}<>}(<>())]]><[(({}<>)({}<>))<<{}<>><<
    {<<({(<[(<[[{{[][]}{{}}}<[[]()]<<>())>]](<{{{}<>}{()<>}}>)>)]<(({{[[[][]]]}<[[(){}]<[]{}>]>}))>
    ({{([<<{[(<<{{<>()}<[]()>}<{(){}}{{}{}}>><(<{}[]>{<>{}})<([]<>)([]())>>>)]}>>[[{<{[<<(<>{})
    <{({{({<<[{<<{<>}{{}[]}>>[[{[]<>}{()()}]<<[][]>(()())>]}]{<<{[(){}><<><>>}{{<>[]}(()<>)}>[<<(){}>[[]
    <({<([[[([({<{(){}}([][])>}<[{[][]}{<>()}]<[(){}][{}<>]>>){<({{}()}{[]{}})>{[{[]{})[()[]]]<[
    {([({[(([<{((({}()){{}<>})(<()[]>{()()})){[({}{})<<>[]>]([{}][()])}}>]{<<[<[[][]]{[][]}>({[]{}}<{}()>)
    <<{[<({[(<[({<{}{}><()()>})]{<<[<><>]>>}>){{[((<<><>><{}[]>)){<{[]()}(<>())>}]{{{({}<>){[]<>}}{{
    <<({<[{(([{({({}())(<>{})}{((){})})[<[[][]]([][])>]}<<[[<>{}][[]<>]]<([]<>)[()()]>><<<{}[]>(()())>>]])[[[
    [{<({<(({([([{[]}]<{[]()}[()<>]>]{{(()())<{}()>}{{[]()}<()<>>}}][{(<[]<>>[<>{}])[<[]<>><<><>>]}<(<<
    <{{((<<(<{({<{<>{}}[[]{}]>})[[{{[][]}{{}<>}}]]}[(([(()[])<()<>>]((<>[])<<>{}>))<[[<>()][<>
    {[([<<<({[{<<[<>{}]<[]<>>>>({<<>{}>((){})}<{[][]}{[]{}}>)}<{(([]{})<<>>><{{}()}(<><>)>}<{<[]
    <({[[{{{([(({[{}<>]{[]<>}}[{()<>}<(){}>])<[<{}()>[[]<>]]>)]{{[<{<>()}[{}()]><<<><>>{[][]}>]([[[][]](<>())
    [<<{{<[[{[<(<{()[]}[(){}]><[()[]]<<>{}>>)>[[[[[]{}]{[][]}]{<[]{}><(){}>}]({{<>()}<<>{}>}({()<>
    [<[[(<[[[[<<<{()<>}[[]()]>>{[[<>[]]{[]{}}]{[<>[]][[]<>]}}>]]({[({[<><>]<{}<>>}<<(){}>[{}()]>)[[<<>
    <{{({<([{({({{{}()}((){})})([([][])[[]<>]](([])[{}<>]))}<(([()<>][()[]])[<[]><{}{}>])<{({}<>)<<>()>}
    {<[[[([{[<<(({{}<>})(<{}()](<>{}))){[[<>[]]({}<>)]}><[((<>()){[][]})[({}())<{}<>>]]<({<>[]}{{}<>
    {<[<[({<({(<(({}[])<{}>)((<>[])({}<>))><(([][])(()()))>)})({{({{<>())}<{<>()}([]{})>)[[(()<>)<<>[]>](<<
    {(<(<<{{({{<{(<>[])[[]]}{(<>{})>>{<(()())[{}{}]>{{[]{}}{{}<>}}}}(<{[{}[]]<(){}>}[[{}{}]{()<>}]>([{<>{}}[<>]]
    [{[{{[[[{([<(({}{})<[][]>)<([]{})<<>{}>>>[{[[]{}]([]<>)}{(()())[<>[]]}}]((<([]<>)[()<>]>(<{}()>)){<[<>[]](
    {<<<<{(({<<({(()())(<>{})}<([][])[[]()]>)[{{[]()}(<>)}]><{[<<>()>]{<[]()>[[]<>]}}>>}>[(<<<[{()<>}{{}<>
    [{[(<[<{<[({[{[]<>}<[][]>]{{<>()}}}[({<>[]}{{}{}}){[[]<>](<><>)}])({({{}<>}<{}<>>)}<[((){})[{
    {<[[{[(((<({([[]<>](()<>))}[{{()<>}({}())}(<[]{}>{[]{}})])<<(({})[{}{}])[(<>{})<()>]>>>))<[{{<[{{}<>}[[][]
    [[<<([{<{((([<{}{}>(<><>)][({}[])])[[(<>{}){{}<>}](<()[]>[[]()])])[{({()}{{}{}})(({}())([]{}))}({[{}[]]{
    <<((<[<(([<{[<{}<>>][<{}{}>{{}[]}]}[{<<>()>[[]{}]}{[()[]]([]{})}]><{({()()}{[]})<{[]()}[{}{}]>}{((<>(
    ({<<{[(({{<<{[[]()]{{}()}}{[<>{}]<[][]>}>{(([]())[<>[]]){<[]{}>{<><>}}}>{{{{<>[]}{{}()]}{{<>{}}[{}{}
    {((<<{<<<((<(({}{})(()))[[()()]{{}<>}]>{(<()[]][{}[]])[[<>[]]<<>>]}))>([[{({()[]}{()[]})(<[][]><{}{}>)}[[[[][
    [(<<{<[(<([<(<[]()><()()>)>]{({[<><>]{[][]}})}}<[([(()())[{}]]<<(){}>[<><>]>)][<<((){})>>[[{<><>}[{}()]][([]
    [<{[<[[(({{{[<{}[]><<>{}}][[{}<>]<<>()>]}{[{[]}[{}[]]]{[()[]]<{}<>>}}}[({<(){}>{{}{}}}<(()[])(
    <{([{(<[<<<<[[{}{}]([])](<{}{}>[[][]])>{{(()[]){<>[]}}<[<><>][(){}]>}>(([[{}{}]{{}<>}](<()()>))<<(<>{})<<
    [(<[[[[(({[<<<<>{}><<><>>>>]<{[{{}<>}<()>]{{[]{}}[<>[]]}}<<<()[]>([]<>)><(<>{}){[]()}>>>}))[[([{<
    [([(({<{([<[({{}{}}<{}{}>)[[[]{}]({}<>)]]<[([]<>)({}[])]{(()[]){[]<>}}>>{[<{[]<>}>{[()[]]<()<>>}][<([
    {<[<[[<[{({{<[[]()][{}()]>({()[]}(()[]))}([[<>()]])})}{{<{{[<>]<[]()>}{<{}[]]}}<{{()[]}<[]<>>}([()()]<{}()>)>
    [{{(<(([([((<{{}{}}({}())>{{<>[]}<[]{}>})([{<>()}{{}<>}]{<()<>>[{}{}]})>]{{[<(<>){[]{}}>{<<>[]>[()[]]}]
    [<<(({[[({({[{[]{}}<<>[]]]{[()()]<<>()>}}{[{<>[]}<()>]}){{<<()[]>{[]{}}><<<>>[[]()]>}}})<[{{[<
    <([{{{(<{{{<<({}()){(){})>{<{}{}>{<>()}}>{(<()[]>({}()))<({}())<()()>>}}[(({[]{}}[<>{}])([{}<>])){{{{}}(<
    <<{[{[[<([[<(<{}<>><()[]>)<{<>()>[<>()]>>]][{{{{()<>}<{}[]>}[<[]()>[()[]]]}<{[{}](<>{})}>}[<[[<><>]<
    [{[([{<<[([[{<<>[]>(<>())}((()())({}{}))>{[({}())<<>()>]<(<><>){()<>}>}]({([(){}]<[]<>>){<[
    [{<<[[<((({[<[[]()]>(<<>>(<>{}))]<<([]<>)[<>{}]>{<[][]>(<>())}>}(([{{}<>}{{}[]}]{[()[]]{{}{}}})<
    ([<<{[([[<{<{({}())}{(()<>)}>[<[{}<>][[]()]><[<>{}]({}[])>]}<[([<>()]){[()<>]([]{})}][[[{}[]]][
    <{[[{({<{(<[[(()[])<<>[]>]<<<>()>{[]<>}>]>{[<(<>()){<>[]}>(([][]))]([<[]<>><{}{}>]([<>{}](()()
    {[([{{(([[<{<[{}<>]([]{})>[((){})<()[]>]}[[{{}<>}<[][]>]<{[]<>}([]())>]>{<{{{}<>}{(){}}]{{[]
    [{{<[([<{[[({[{}[]][(){}]}<{<>()}<[]{}>>)]<<({()<>}[[]()]){[<>[]]<()()>}>>]{[<<(<>[])<[]<>>
    <[{<[<((<({[{[{}[])(<>{})}(({}[])[<>])]})>[[([{((){})<<>>}])[<((()<>)[{}{}])[[(){}]]>{<<{}()>{
    ({[[[[[[[<((<[<><>][()[]]><(<><>)>))>{{<(<<>[]>{{}})[[[]<>]({}())]><{{()<>>[[]<>]}[<{}{}>{<>{}}]>}[{<(<
    ([([(<[{<[[{<{<>[]}>{{{}()]<{}()>}}<([{}()]{{}<>})[([][]){{}<>}]>]{<{{[]{}}{{}<>}}<[[]()]>>[[{()[]}{(){}}]{[
    {<{([([{<<<<{[<>()]<[]>}[[()<>]<()>]>>(([[<>[]][{}{}]])((([][]){<><>})([[]{}]<()<>})))><{<<[()()]<[]()>
    [{({[{[(([([{{{}<>}{()<>}}(([]<>){{}{}})][<{()}{{}{}}>(<<>()>[<>()])])]))<<<({((<>()){[]{}})[{
    ([([(<(({<(<<<{}[]>){{<><>}[[]{}]}>[{{[][]}<<><>>}])<{<<[]>(()[])>[[{}()]<[]<>>]}{({[]()}[<><>]){{{}[]}[{
    {{[{<{((<((<<<(){}>>{([]{})[[]()]}>([({}{})]{<()>{[]{}}}))[[(<<><>>)]<<<{}{}><(){}>>[({}[])({}
    <{[({{<<((([[[(){}][{}<>]]<(<>[])<[]()>>]<[[{}()]({}())]>)({<[(){}]>{(<><>){[]{}}}})){{{<<[]()>[()<>]>[<
    (<[[(<((<[[<{[[]()][()<>]}<[[][]]<[][]>>>((({}())((){}))(<{}<>]{()()}))]]>[[{<{[{}<>]}>([[{}<>](()
    <<<{<(<[<{[[([<>()][()<>])(<<>()>[{}()])][<{<>()}>]]}<<<({<>[]}([]{}))<<(){}>>>[[({}())(())]]>{({({}[
    ([<<<{<{({<[{(()<>)<()()>}]<[({}<>)]>>{[[{<>{}}(()[])](<<>>[[]<>])]}}{<<{<<>()>}><{{<>()}<<><>>}{<(){}>[(){
    {{(<<[{{({({({[]()}<{}()>)(([][])[()<>])}<{(<>())[()<>]}>)[[(([]<>)[[]<>])]]}[({[({}()){{}>]})
    <((((<{{{{{[{[(){}]([][])}[{<>{}}([]<>)]]([((){})]<[[][]][<><>]>)}}<(<{(()<>)([]{})}><([()<>]{<>()
    <{<{<(<(<<<(<[[][]]<<>()>><[<>[]][[]]>)[<[<>{}][<>()]>]>{<{(()){{}()}}[<{}<>><<><>>]>[{<{}[]><<><>>}]}>{(
    {[{<<(<([({{<<[]<>>[<>{}]>{<{}<>>([]<>)}}([<<>{}>((){})}<{<>[]}>)}<<({{}()})<(<>[])[[]]>>[[<<>[]>{()[]}][[[]
    <<<<[<{<[{{(<[<>]<[]{}>><(<>{}){{}()}>)[[{<>{}}{{}[]}](<[]>[<>{}])]}{{[{{}[]}(()<>)]<([]())(
    [([({[[{<{{<<{()()}<{}{}>>({{}{}}[{}{}]>>[{(<>{})<()()>}[[<>[]]<{}()>]]}[<<{<><>}(()[])>(<{}[]>
    [<<[[(({<[[([(<>[]){()[]}][(<><>)[<>[]]])]<({<{}{}>(()[])}[<{}<>>({}())])((({}{})<{}[]>)[{{}<>}{{}{}}])
    (({({[<<[<[([<<><>){[]{}}][<()<>><[]<>>])({[{}<>]<[]<>>}<({}{})[{}[]]>)][{((<><>)(()[]))}[<<{}()>{<>
    <((<[(<(<[[([{(){}}<<>()>]({(){}}{(){}}))]][{{[{[][]]{<>{}}]{[{}<>]([]{})}}}[<{[[]{}][<>()]}[(()[])<
    {((<<{({<[([(([]())([]()))(<[][]>{()})])<<[<<>[]>[<>())](<()<>><()()>)>>]>{{[{<[<>{}]<[]<>>>}<{{<><>}<
    {<<<<[((<{({<{<>[]}{<>()}><{<><>){<>()}>}([[[]()][(){}]]<<()<>>{<><>}>)){[{{<>[]}{[]()}}{(<>())
    ({<<<<[{<{<{(<{}{}><()[]>)[{<>{}}]}>(<[([]{}){<><>}]{<<><>>[()[]]}}<[{()[]}{()[]}][{{}[]}{[][]}]>)}>}]
    ({({{<{{{[<{{(<><>)}({[]()}{<><>})}{<[{}[]]<[]<>>>[(<>[]){()()}]}><[[<<>()><[][]>]]>]<<[{[[]()](
    <{[<([<[({([{(<>{}){()}}<([]<>)[{}{}]>)[[<()[]><{}<>>][(<>{})[()()]]]){<{({}){{}{}}}<{<>()}[[
    {((({[{<{[<({[{}()]({}{})}<(<>)(()())>)({[[]{}](<><>)}[<<>[]>[<>[]]])><<[{[]<>}][([][])<[]()>]>(
    ({[((([<[(<{[(<>[])(()[])]}<[([][])([]<>)]<(()())>>>((([(){}])<(<>())<<><>>>)<[[()<>>{{}{}
    [{{((<{[(<{[{{[][]}{<><>}}[[()[]]<[][]>]]<<({}[])((){})>>}>[(<([[]()]<{}[]>)([{}<>])>({<<>[]>(<>[])}[(
    ((<((<[<(<[{(<[]()>[()[]])((())(()[]))}{[[{}<>]([]{})]<[[]()]>}]>)><([<[<{[]<>}<{}[]>>[[(){}]]]({[[][]]{
    [(([([(([<<(<{<>}{[][]}>)[{[()<>]{{}{}}}({{}{}}<[]()>)]>>{([({<><>}<[]>){<{}{}>[()<>]}]<<[[]{}]{{
    [(<{<[[{[<<{<[[]<>]<[]()>>{{[]<>}}}><[[{{}()}([]<>)]][({{}<>}{{}{}})<[[][]](()())>]>><<({([]{})<<>{}>}){
    <{[<[(<<[[[[{<{}[]><[]<>>](<{}[]>{()[]})](<[<>()][[][]]>([()()]<<>()>))]]({([<()[]>[{}()]])<{[[]()]}{<[][
    <{{{([[([{{{<({}[])>}}<<({<>{}}{{}()))<({}{}){[]{}}>>[[(<>())[{}[]]]<<[]{}>{<>[]}>]>}([{[<<
    [{<(({{<[{[[([<>{}]{<>{}})(((){})[{}[]])][{<{}<>>}[([]{})<{}>]]]}{<<([<>{}][()[]})[{{}}<{}()>]>(
    [((<[{<<[<[{[{{}()}[{}[]]]<[<>[]][{}<>]>}]>]{[([([[]<>]{{}[]})[<(){}>[()[]]]]<<({}[])<[]()>>[(
    [{([<{([(({(<[[]<>]>{({}()){<><>}})([([]())[[]<>]])}(<[({}())(<>())]<{()<>}[[]<>]>>)){{([[<><>][()[]>](<[][]>
    <<(<<<{{{<<(<<[]<>>{<>()}>[<[]>])<{<{}<>>}{[{}{}]<<>[]>}>><{<<<>{}>({}<>)>}{([()[]]<<>()>)(<<><>><[]{}>)}>><
    {[<<[{{(<<[((({}{})[{}{}])(({}<>)[{}()]))]>{([[[(){}]<{}<>>][[{}[]]{()[]}]](<{[]{}}(<>[]>>))}>)}[(<
    <{{[[<[[[(((({<><>}{{}{}})<[<>()]([]())>)[<{{}<>}>{((){})[[][]]}]))<{<{[[]()]<[][]>}{<[]<>>(<>
    {<[<<([[[[{{<({}<>)<{}()>>[(<>())({}[])]}<{([][])({}<>)}>}(({[<>{}]{[]{}}}<(<>{})>)[<{[][]}{[][]}>{({}()){
    [[({{[(((({<{{<><>]}{(<><>){<><>}}>(<[()<>]<{}{}>>((<><>){<>[]}))}{<[[{}[]]([][])][{{}[]}[
    [{{<([((<<{(((<><>)<(){}>))((({}[]){<>()})(<{}()}({}{})))}><[<<{<>[]}[()<>]>{[<>{}]{[]()}}>{{
    [<{<{{({{<<<{[<><>]<[][]>}<<(){}>(<>)>>>([<{[]()}{{}[]}>{<{}()><[]<>>}]([([]())[[]]]([[]()]<<>{}>)))>
    <[{<[(<{{([[<[{}{}]><([]<>)(()())>][<((){})[[]()]>[([]<>){<><>}]]]{<{<[]<>><<>>}{<{}<>><[]{}
    {[((((((({([([(){}]([]<>)){[{}](<>[])}]{[<<>()>([]<>)]<<[][]>{[]<>}>})<<[{{}[]}(<><>)]<[()<>]
    ([({(([[[([[((<>{}){{}{}}]{[()<>]((){})}]((({})(<>[])){[{}{}]<<>()>})]{({(())[<>{}]}((<>{})
    {<[<{(<[{<[{(<{}()>)[<<>[]>(()<>)]}([{()[]}<{}<>>])}(({<[]{}><{}{}>}([[]<>]{{}()})){[[{}<>]
    <<({[[<<[([(<[<><>]{<>{}}>{<(){}>(()())})<{[<>{}]<()[]>}>]<{[{<>{}}<<>()>]<{{}()}[()<>]>}<[[{}<>][{
    """

do {
//    try corruptedScore(for: puzzleInput) // 394647 (correct)
} catch {
    error
}

do {
    try chunkChecker("[({(<(())[]>[[{[]{<()<>>")
    try chunkChecker("[(()[<>])]({[<{<<[]>>(")
    try chunkChecker("(((({<>}<{<{<>}{[]{[]{}")
    try chunkChecker("{<[[]]>}<{[{[{[]{()[[[]")
    try chunkChecker("<{([{{}}[<[[[<>{}]]]>[]]")
} catch {
    error
}

func completionScore(required: [Character]) throws -> Int {
    try required.reduce(0) { soFar, character in
        let multiplied = soFar * 5
        
        switch character {
            case ")":
                return multiplied + 1
            case "]":
                return multiplied + 2
            case "}":
                return multiplied + 3
            case ">":
                return multiplied + 4
            default:
                throw Error.unexpectedCharacter(character)
        }
    }
}

func completionScore(line: String) throws -> Int {
    let result = try chunkChecker(line)
    
    if case let .incomplete(requires) = result {
        return try completionScore(required: requires)
    } else {
        return 0
    }
}

do {
    try completionScore(line: "[({(<(())[]>[[{[]{<()<>>")
    try completionScore(line: "[(()[<>])]({[<{<<[]>>(")
    try completionScore(line: "(((({<>}<{<{<>}{[]{[]{}")
    try completionScore(line: "{<[[]]>}<{[{[{[]{()[[[]")
    try completionScore(line: "<{([{{}}[<[[[<>{}]]]>[]]")
} catch {
    error
}

func completionScoreWinner(input: String) throws -> Int {
    let incompleteScores = try input
        .components(separatedBy: .newlines)
        .map(chunkChecker)
        .compactMap { result -> [Character]? in guard case let ChunkResult.incomplete(required) = result else { return nil }; return required }
        .map(completionScore)
        .sorted()

    return incompleteScores[Int((Double(incompleteScores.count) / 2) - 0.5)]
}

do {
//    try completionScoreWinner(input: exampleInput)
//    try completionScoreWinner(input: puzzleInput) // 2380061249 (correct)
} catch {
    error
}
