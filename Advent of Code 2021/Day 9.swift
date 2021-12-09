//
//  Day 9.swift
//  Advent of Code 2021
//
//  Created by James Coleman on 09/12/2021.
//

import Foundation

extension Collection {
    subscript (safe index: Index) -> Element? {
        if indices.contains(index) {
            return self[index]
        } else {
            return nil
        }
    }
}

class Point {
    let position: CGPoint
    
    let height: Int
    /// Height + 1
    let score: Int
    
    private var neighbours: [Point]
    
    init(x: Int, y: Int, height: Int) {
        self.position = CGPoint(x: x, y: y)
        
        self.height = height
        self.score = height + 1
        self.neighbours = []
    }
    
    func set(neighbours: [Point?]) {
        self.neighbours = neighbours.compactMap { $0 }
    }
    
    var lowestPoint: Point {
        let neighboursSortedByHeight = neighbours.sorted(by: { $0.height < $1.height })
        if let firstPoint = neighboursSortedByHeight.first {
            if firstPoint.height < self.height {
                return firstPoint.lowestPoint
            } else {
                return self
            }
        } else {
            return self
        }
    }
    
    static func factory(input: String) -> [[Point]] {
        var arrayToReturn = [[Point]]()
        
        for (y, line) in input.components(separatedBy: .newlines).enumerated() {
            var array = [Point]()
            
            for (x, character) in line.enumerated() {
                if let int = Int(String(character)) {
                    let newPoint = Point(x: x, y: y, height: int)
                    array += [newPoint]
                }
            }
            
            arrayToReturn += [array]
        }
        
        for (y, line) in arrayToReturn.enumerated() {
            for (x, point) in line.enumerated() {
                let above = arrayToReturn[safe: y - 1]?[safe: x]
                let below = arrayToReturn[safe: y + 1]?[safe: x]
                let left = arrayToReturn[safe: y]?[safe: x - 1]
                let right = arrayToReturn[safe: y]?[safe: x + 1]
                
                point.set(neighbours: [above, below, left, right])
            }
        }
        
        return arrayToReturn
    }
    
    static func lowestPoints(for input: [[Point]]) -> Set<Point> {
        let lowestPoints = input.flatMap { $0.map { $0.lowestPoint }}
        
        return Set(lowestPoints)
    }
    
    static func sumRiskLevels(of points: Set<Point>) -> Int {
        points.reduce(0) { soFar, next in
            if next.height == 9 {
                // Plateau
                return soFar
            } else {
                return soFar + next.score
            }
        }
    }
    
    static func basins(from points: [[Point]]) -> [Point: Set<Point>] {
        var dict = [Point: Set<Point>]()
        
        let lowestPoints = lowestPoints(for: points)
        
        for point in lowestPoints {
            guard point.height < 9 else { continue }
            dict[point] = [point]
        }
        
        for line in points {
            for point in line {
                guard point.height < 9 else { continue }
                
                let lowestPoint = point.lowestPoint
                
                if let existingSet = dict[lowestPoint] {
                    dict[lowestPoint] = existingSet.union([point])
                } else {
                    // Should never happen
                    dict[lowestPoint] = [point]
                }
            }
        }
        
        return dict
    }
}

extension Point: Hashable {
    static func == (lhs: Point, rhs: Point) -> Bool {
        lhs.position == rhs.position && lhs.height == rhs.height
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(position)
        hasher.combine(height)
    }
}

extension Point: CustomStringConvertible {
    var description: String {
        "\(position.x), \(position.y), \(score)"
    }
}

func day9() {
    let puzzleInput = """
        7654598954321095410125798754578999894323456789349878901298743234767897899987654234567895493239656798
        6543487895992987324234599543467998789934567893298767892987643123457976789998762123456789989198768987
        7632356789889876535345987654788987678897678954997656789998784434578965699999878244678997978999999876
        7543487896673987676767898995689876556789789769876545698999896549989434988799954345989896767899886765
        9854567965432398989898959987789987347899899879765434567893987698999549877669875656798765656998765454
        8767778954321239799979545299897898258976989989898545679932198987987698765457989767897654343987654323
        9878989765932345689965432134956789349965678999987656998991019876798987654346799898998743212398787634
        9989999979896456789876541012347898767894567899898769897989198765689996543235678969987632101239896545
        9999987898789767899985432123456789898993678998789898796778987654677897652124689659876543212548987656
        8999876765678998989996543234567899969789799987678997655569898943456894321034569543987854433467898767
        7898765454578949678987854345688989954656989876549876543456789852345789632123458932398767654878949878
        6987654323469434589798975458799569893239876957234987632347898761245689543234567893499898965989432999
        5698765545678995695699876569893456789198765432145698743456987650156897656745689994989989899998949976
        4569877658799989954987987678974567891019898547656899856769898741456789789856789989878965798987998765
        3567998969989877896996598789765678943423987668767956967898765432367899893979899876767954567896899994
        2357679879878766789895459899899889654654598979979349878939898543498987991989999765656893678965798789
        1234589998769655456799349978912998798777679899899556989321987654567896889999997654346789799654987678
        0395679319943242345678998767899879899988789798788967896532399765678965678909876543234599898943498989
        1989989429832101236789987656998765976799998674667998987649499887889434599214987653125989987892349994
        9878998998763212367895498547899894345999876543456899298798989998997323989923987432014578976989457893
        8867897987654723456789597634989989459898765632566789349897678999765439879894986542123456895678998912
        7658956798765674567999999745678978998769854320175898959986569899876598767789997656254589934599889201
        6545697899986897678989899869899569987656965431234567898775458789987699654678998867767678910987678912
        7656789998997998989976789878923498899549876532678979987654349689998986543567999988878989329976567893
        8789891297698979398765398989549987678932998743569989876743234567989995432178898799989799498765458989
        9898989975459763209879987899998976567891987656798795975432125698979876543236789642395678987654345678
        4987678984348954345998976789876565457890999767897654986543026789767987674345894321024567898543234567
        3986567895467895956987895678975434356999879888998543297654534895455698765667895933235878987432103458
        9895456789578999899876724567954321234598765999789432198785675954324789887779999894345699876553212667
        6754345678989998798765213479543210145987654545678944569896786943212398998889998795456789987664333569
        5421234789999987679854374678954321259876543234599655679987897894103987769999997689567899899965654698
        4310123678999976598765465678998542367965432123698769798698998965212396556789876578978998768898765987
        5523234599998765439876566789987656459876521012789978987549899954334965434898765467899999656789879876
        7654345678989876321989699892198767867998643223898989998634789876449896525987654356789986547678989985
        8795959789878987530198789921019878989987654354567897899745678987898765434598876245699875434567898954
        9989898999769876545239896542199999999798765469798976799898789599939878545679765123987654323456987653
        9876787898954989654345987543578934987659986878939995989939995432323989959797543245798545212347896742
        9985676567969898765467897664989123498547897989023989678924789541012399898987674356987632101498965431
        9654324456998789898567999879991012999656798998939876569015678932143498787898789569876543412359894320
        8743212345897698987688987989989139898767899567899987894323799993254987656789899878989654323456789431
        9854599456789587898799876797878999789979923456999898965434989989345986545699932999998765434567896542
        7965678567893436999898765456567987679989212377898769876559878978959877321789921989899878755678976543
        6798789678932125899987654343459876578997602457997653987698967869898766210867892979789989867889987654
        5679898789543234789999743212345965469876543458943212398987856956789854321456999767678999878991098967
        4298969897654545678987654343459876568987754567894323459996543245698766432378987654569899999892989878
        5987654998787679799998765654569987678999865678965654698875442134459887543569876543458789876789876989
        6798543459898789898999876767898998789434976789998785987654321012345998764598765432345678965498765498
        7987632367999891967789989898987859899325987899989899898765532133498999878909854321234589874349986567
        9876521459895910145694393999876745978976798999879998769876743654567898999919873210145698943235987678
        8765410498754321234893212598765434567897949998768999954987858795678967987896954321234567892126998789
        7654321239875436545789343459876745678998934989656589892098969989789459896545967434345678921019899893
        8987432389876587656789754567987896789239895976545476789129998978994398765429876545559789992398765912
        9876543478987698769999967878998989897456789895432345678934987656789219873212987656767999989987654101
        9987654569998899898899898989899878976567898789321234578949896545898998754101498767898999878986543212
        9998987678969910987778789998768767898978989678910123789798765435667899968912369878959989769897656323
        8949798799654329896565678987657656899989878569434236897698754323458789879893458989345678956798787434
        7939659899965698785454567898542546788998765458946345896597653212345678998799567893234569543239996565
        6898946999896987676323458987651234567899876767895456789987432101234589989678978942123498932123987876
        5687899998789996543212767898540145678999987898976587998996543212347679878567899543014567893234598987
        4546678987678987652103456789432234589989998989987698977987654323456798765456987654165678954545679998
        3234567986568997653212367896543445678978949876798789766498765634567899874345896543236799765676789999
        4345679875476798765435458987654598789765432765689897654329886797678932965212789754347899898787899887
        5678989994365679896547569998895679899876741534589986543212999898999549984345678965458999979898945676
        8789299976234569999658678939976789998998810125678987654109212999745998765756789876567898763999432445
        9891019876345678998769789923987892987654323236989998783298999987659899876867893987689987651299921234
        7942323965476989019878899895998921099798434587999999894987888998798789989978932398789299740987892545
        6543499876787893298989998789899933129897659678989899999876567899897698799989321239899398921976789656
        9654987987898994987899987676789896534999798989878789998765437899986545678996560123978987899875678967
        8769876598939989876789876545696789645698987898765678987654326799765434569897671234569876797654589998
        9879765439123878985698765434545678956987876789654567899976715987654323456789982367898765679863689989
        9998974321012367894349854321234567899876765678943456789897924598765434878996543456789876889954599878
        9876795432123456999298765410123456789965634567892567898789897679876565989997656567896989999875789767
        1965689943234567898949876523534567899854323456789678987698789799989696799879897679945691012986797545
        2954567899999678997834987854678978998765414567898789876544678989998789898965969895434889129799896535
        9876698978788989986325698998789989349876565878999899965433567878999892967893459954323978998656965421
        4988789767687899965434789589894391234987676789899998765322346567898901256932398767434569997345799210
        3499899856566789876895893478943210123498989896789999893210123457897432347899499876567878986234987921
        2345978943455678987976912367954934534569991935889898954321434568996543656998989997678989765349876899
        1234567891234589798987893459899895675698910123679767898543565679987654578987878998789199876598765798
        0123459932345697679999954598789789896987851234569656987654678789998765689876667899893234987679894626
        1245678943456789567899967987657678989986543447678945699865789899999898789765456789989349998789983515
        2356899767567893456799899898434569878987894758789234569976898999876949897654345679879498999899872103
        3987999878678912345987656789923459965698996769894345678989987689765634989993234798968987899998763212
        4598987989789923459876544567894598754569987878965467889899876599874329878789345987657676789987654323
        6679876799899854569865433456965679987678998989976567998789965499965498767678959876542545989998765434
        7898965678998765698765212368896789998789659597897678987678996989876987654567899984321234578999896545
        8987894389789876789854323456789998999898743456789789996567989878987898543468999893210345689999987678
        9456954245678989899965676567899897989919654568999899987679879967898987658979098764321456799989598989
        7677892134567892979876789878998775878909798679346989198798767856789998767889199765432347899875459899
        8789921012678943459987892989899654767698998791235679019987658347698999898991989899843678998764345679
        9899432123489994598998901997789543457567899892346789129876545236587899939690978998764589569853236789
        9998743484569889997899219875695432143456799943456789298765432123456789323489765679965694456932125898
        9899654567698779876789923994589521012345898954967898999877651012347897435678954567987892399893234567
        8798765679987654987999899965679432123476997899878967898998432123478976566789543476998943987789345678
        7659898789878743499998798896789543454569896989989854867899843254567898977995432345899659876568956799
        6546979898765432578998667799897654767698785678997643656798754365678959998976541276798969876489969896
        5435367999878543458998546678998767899987654567896532345679765476789345999987652567987897687349899945
        4321256789987676567987634567899878998998323456989421236789876587894233898998743459876789543246789434
        3210345678998987678998745688954989987569212345678965456789987698943102767899854598765897652125679323
        5421456789109999789987656789543499876432101234789876567891099789656813456932965679854999873234568912
        """

    let puzzlePoints = Point.factory(input: puzzleInput)

    // MARK: Part 1
    
//    let puzzleLowestPoints = Point.lowestPoints(for: puzzlePoints)

//    print(puzzleLowestPoints)

//    let puzzleSum = Point.sumRiskLevels(of: puzzleLowestPoints)

//    print(puzzleSum) // 512 (correct)
    
    // MARK: Part 1 Debug
    
//    let puzzleMapped = puzzlePoints.map { $0.map { $0.lowestPoint == $0 ? "\($0.height)" : "." }.reduce("", +) }
//
//    for line in puzzleMapped {
//        print(line)
//    }
    
    // MARK: Part 2

    let puzzleBasins = Point.basins(from: puzzlePoints)

    let puzzleReduced = puzzleBasins.reduce([Int]()) { soFar, nextDictPair in
        soFar + [nextDictPair.value.count]
    }.sorted(by: >)

    let puzzleTopThree = puzzleReduced[...2]

    let puzzleProduct = puzzleTopThree.reduce(1) { soFar, next in
        soFar * next
    }
    
    print(puzzleProduct) // 1600104 (correct)
}
