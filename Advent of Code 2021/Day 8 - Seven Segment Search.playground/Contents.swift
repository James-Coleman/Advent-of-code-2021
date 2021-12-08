import Foundation

var greeting = "Hello, playground"

let puzzleInput = """
    eb cbgfae cabdf fedab efb adgcef cbgaefd egdb dbgefa eafgd | dfbae be gdafe gcefab
    bfcae acegfd dbfac daf bgfdc dfgaceb gfebdc da dbag cdgbaf | bgfdc dfcba bdegfc efadcg
    afgdb dcge ed dfe geafcd aefdcb adgef gfcea gdbecfa agfceb | dfe ceabdf efbcag gefacd
    ebad gbfed dfe caefdbg gdbcf fgcdae de fdgabe efbag gabecf | gacfed bgedf dfebgac befga
    dabegfc gfeab gdefbc ecagdb bcfd fd ecdgb adgfec bfdge dgf | efbag egbdf ceagfd dfegb
    bfadge dbgec fgbdce cafbgde gbe gcbafd cfbe be cgbdf aedcg | bcdeg egacd beg cgedb
    aecfgd dabcegf gca dbgacf gc degbaf caged gefc adebc agfed | agc gc cg fdgaebc
    beagfc ecf agdecbf cf acfd dgace deafgc efbgd gdfce gadbce | decfbga dbaceg bfgde gdecfa
    cgbef dafeg fdc gbadfc cbed aedbcgf cd bfagce fcgde efgcdb | gefcd fgacbd cd bfegdc
    bce efdcbg ebgfda cbfgae bdegc ce dfec dbefg cgadb edcfgab | cfaebgd bedgc cfed efcd
    gedcfba cfbdg dgecf bafdcg efbgda cbed efd bcfged de afegc | bfcdg agefc fabdgec fegca
    fa dgcef gfacd bdgac fcbegd fedcga adef fcgaebd afbgec acf | gefdac egfcbda egfdc gefdca
    ebcgf dagbc cfedga cfgba afg agebfc befa dcfgaeb af edbgcf | cbgefd acdgb afdgce fabe
    gfe fg fdageb bgfd cagfde abegf baecf daegb cabged cgfdeba | gfe gdafbce fg bgdf
    bagdce acfbd faebcgd dae fecdbg ageb ae dbcae defacg gedcb | dea eabg bcdae aecdb
    gceaf dagc eda febcagd gebdaf ecafdg deacf ad cdebf abgcef | fdaec fdebc dcfae ade
    adebcfg ecd ecbag bgaecf cgdfb afecdb gbedc caedbg aegd ed | bedcag gabecf dcgfb fcabed
    fbecda cabgf dg deag cdeagf gdf begcdfa acfed cfagd dcegfb | dg edcfa gefdbc gdea
    gfbcad dafbge fdcbea dgbfa dbeag eb eba eadcg bgef edgfcab | agbed degafb eagdb caedg
    aegbdc fecdgb eac cgefab fecag abcf ca dbgeafc gebcf fedga | fbgecad abfc cgefba agcef
    dc fcda gadbec fabcgde gbcfda dcg befcg deabfg bgdcf fgdba | cdfa acfdebg fgadbe ecfbg
    cdbagf gcf badgc fgdac fc cbgead fbcd defga ecagbf gdbafce | gfabdc bdcf gcdab fdcb
    cfdabe faedc febcg acbd abf cdagfe ebdgcaf bdgfea ba beafc | fab bafdce dacbfe fab
    eag cfedba aecgdfb deafgb agcdb gefc eg gdeafc ecadg cedfa | fedabc gbadc bacdg gecad
    fgcae afbdec cad edfab cedfa cdfb bdceag bfdeag fdgecba dc | ecagf dc fdecab cdaef
    fcegbd dagefb dbf cgfbd eafcdg dbagc cfdeg gecbafd fb efcb | bf efcgd gdcef gbfedc
    dgbcfe dagef fcbadg fdceg efbc edgbfca deabgc ec cbdfg gec | feagd dbafgec fdgcb bdgaecf
    fgbcd dagcef fb begfac cbdge bcf gacfd gafbdc gbfadce adfb | bfc bcdgf deagcf fgdbc
    gafdbe gefba bf gbdaec faecg bcgfead bgdf efb acfbde gdeba | becagd bf bdfg fb
    af agdcfbe aegfbc agdf dfbce acdbf fab edabgc cdabg gdbafc | dagf fa bdfce bfgdca
    edfgba edbgf afb beadc gbcdfae dfga afgceb af edbaf gefbcd | efgcba ebagdf dbgfe fa
    fecba df dbf dcefgba dgaf aefbd decbgf bcdeag begad deafbg | acbedg degabc fdebcg deabg
    cgabedf abd daebgf gbde db bdaefc fecgad cagfb gabdf edfga | gabfc cgbaf beagcdf cafdge
    efdgb fbe adcbfe edfbga cafgbde gefdca be eagb gbfdc geafd | eb eabg bega abfgde
    cfadg bfeacg gae ecdfga dgcea fabdcg efgbacd aecbd ge fedg | adcgef fdgaec gdface gcfadb
    gabd fcdbag cagfbe deafgc dcbaf ad bdefc dca dcbefag bcagf | facdb gceadf dagb bcafg
    adc eabfcd ecbgad dfab bedfc edcfa ecafg fecbdg fdaebgc ad | cadebf egcaf gaecf febdc
    gfdab cd agcbef cedf ecabdf ebacf febdgca dbcgea fbdca dcb | fabdc fcbdae acebf dc
    bagcd gdabfc dcg fgecdb dc dfcbaeg cbage dfgba dcfa dfbega | dc egbfcad gfdba dgc
    deb beacd cdbga gbdfce cegfbda abgced be dacfbg agbe cfeda | gfbcad deb ebd cgadeb
    efbag gbe gbaefc adbefcg gb bacg efbacd edafg bgdfec abcfe | bacg gfead dfeag dbfgce
    gdbfea dacgfb dacbfge fgceb cd afedb efcdba bcfed cdb ecad | gdfacb bdgfea ecgbf ecda
    caedbf dcge abgdc gcfbae fcdbgae bcg abcedg bgdfa cg decba | acdgbe cg gbc ecfdabg
    adfce bdefga acdgfeb fadeg gecdba gebf bfcagd afg ebdga fg | bdage fg edafbg fgadbe
    gfbdec cabdf dca fgca gbcdf ca fbaed cagbdf fagbced eadgcb | ac badecg afbde bcdfeg
    gdc agbed adbgc abgfc eabgfcd acfd dc gecfdb cfeagb gcafbd | fdac beadg gcafbd cdabg
    cf ecgfadb ecabdg begcaf bfadc fabdgc dbacg cgdf bfade cfb | dafbc cadgb becfdag cbf
    fda abgfe gcadbf cdae egfcad bfedcg gcfed ad dfega fgdeacb | cgdef efcbgda fbgdeca eacd
    ef ebfcad dceag acgbdf fec bagfedc fbeg ecgdf ebdfcg bfgcd | efcgd bgef fdcgb gfcbd
    gadbecf bdgcea fb bafedg bfcdag bdfc aefgc dabgc facgb baf | abf adfebg fba bdagc
    afgceb dfcba cdeb gafdecb bcf edfcba bc aedfc fdbga fcaedg | fbedgca efcgda ebacfg deabcf
    gefbcad cgfbd cagdf dfa fa gdaefb fabc cefdgb aedgc gbcdfa | deafbg caegd ebfadcg dfa
    bfced gdabfc dbeac afgdce fegb dfgcaeb egdbcf fce fe dbfcg | bfdce cdegfa acdegf befdc
    edb befcda fabcd ed adbce cfbaegd fbcgad cedf gcaeb agebdf | fegdab bed fgaecdb afdecb
    fbea gebdac gbdea fbeagd gdfab fa dfa adfcegb aecfdg bgcdf | faebdg cfbdgea dbcgf adbgf
    eac cgabef aebgf cgbde dfebcag efadbc aegbc daefbg facg ca | fcag eabfcg cae cgbde
    ce fce gdefb geca dcfeg afdcg gfcdea ecabgdf gbfdac cedafb | gcefd fcdage gdacf gefcd
    fbdcgea fabcg ebafg gfecab fge gebc bdfcag debaf eg fgdeca | acgfb bacfg cgbfa gfbea
    acdeb gcedba befac bacdgef gfbec fbdeca afc fdceag fa dabf | baegdc gecfb dgfeca bafcdge
    dfgbc deagfcb cfga dabgc fagbed cfbgda bfedcg ag abg adceb | gdfceba cgdab dbcea ga
    ecafbg ge feg cadef decfabg begd geafd dfgacb gfdaeb gbafd | dacef ge gef faedg
    gabecd ecdag edabc fdcbgae ebdafc bcdg gbadef dg cfage edg | cgbade cbgd cgdb edfbgca
    beca bgead fbecgd fbagcde cb gbc egfdab dgfac dgbac eabcgd | gaebd dcafg dbgefca abec
    bcfea ead cebda fbdcge dgabce gedbc fcdage da dcafebg badg | cbged aegfcd dbag agdb
    cefagd gfbedc fagc acedb efc aefbdg afcde fc gafed febgdac | feabdg ceafgd eacfdg feagdc
    dbegfa aefdcbg bafecd cd cfaged bfade febdc adcb dcf cfbge | cd badfe dbca bdgfae
    dcfa eaf aedgfc aecgbfd efcag fa edabfg fegdbc cgedf agbec | ceagb cfbdeg gabedf fa
    db eadgbf dagfc gbefdc egbcaf bdegafc debc fbd bcdgf fegcb | gfcedb ebdc eagbfd ecbd
    cb cgbafde dcfegb cdfgae facb bcg degab gefacb caefg cgbea | degba bfgedc egacb egcfa
    gbcfd dabgfe abecfgd beagcf cg gcad bgadf fdecb bafdgc gbc | abegdf dagfeb cdebf gcbdf
    bfaedc deabgf aecbf fgcba ec bdefacg aedc fcbgde dbafe bce | gfcdbea fbdae bdcaef ec
    bedafgc dgcbfa ebc afgcb cfade geba debfcg cgfbea ceabf eb | faedc ebga bega baeg
    dfeag acegd cae bgdca gdefab ec cefd cadgefb eadfcg fabcge | faecgb gedaf eca aec
    abgf cgebdfa dfcab adcfg cdbgaf bdcefg efcdga dfb bf abecd | gfeadc baecd gcdeaf bfegdc
    cbgde egfadc dafec abdf cba ba afgecb bdeac aedbcf adecfbg | eadfc debcg abc ba
    ecdfgb adecgf fcged cbef bdceagf bde adgbc cbgde gbfead eb | agdcef dfabge eb cedfag
    dgb bg dgfaec efadg bedag afbg bagfdce bfcegd edabc agebfd | befdga dgbea dceab ebadg
    cfbe agedb bcg acefg acegfdb bgafec aecbg gafced abgfcd cb | cgbadf adfgcb gfacbed cdeagf
    gadfc bag acgdbf abfgce bfgda fedcag dfcegab gb fdeba gdbc | bcfgae febad bg bag
    cbaef fgea gabfdc fac cegdba ecabg fdebc ceagfdb af gaefbc | gfcbad dbcage cbaef fca
    bace bdcfe bfgedc afb cabdfe ab aegdf befad agecbfd dfcgab | ab cebgfd bace fdgbeac
    agfb bgcad edgca becfda cabfgd gefdcb ba cabdgef bcdfg bad | cdabg daceg bda bgfdc
    cbefad gcfbade bdcgf edcaf gad acfegd dfeagb ga gcea cdagf | gda ag agd ga
    agc adgec ca cgdfe bfdcaeg cdfbge cedfga edagb acbgef facd | abgde bdfcaeg gdabe gca
    egcda degcb fabcgde fgaebd be gfdeac ecab bde gfcdb edgbac | dbe afgbde ecab deb
    defbga bceg cabgef cadgbef agefb dfgcba becaf dceaf bc cba | gaebf cafeb bc dfacgb
    bedag bdfcea dfbacg efdg ebcga abedfcg dg aefbd gbdfae bdg | caebg degbcaf gbcfda efadb
    eb bacdf bde bega gdfaec daecg dafcbge acdbge cdabe ecdfgb | agecd eb edb bde
    gabcd dcafbe edacgb badce gdcefba fgabc dcbgfe dg dage dgb | dg ceafgdb dfgbec ceadbg
    acedb geadcb cafd edf fdcegb dbfae dfcabe fd agfdbce agbfe | adfbe dcbaef dcaf eagfb
    dgfb daebcf gaced dab ecgbfad eabfgc db gabedf fgeba agbed | bd bd acedfb fcdbega
    daebf befdac gf bdecfag egfb gabefd adfgbc fgeda fgd cdage | agedc fg fdbeac defcab
    bcgda egbdac bgf dgbface cagbdf afcb fb ecfdgb edgfa gadbf | fbcegd egcbfd adgfcb dgbaec
    de ebcfa dec bacegdf afdbec ecgbaf fcaed cafgd bfde cedabg | cdeagb cfgabde fbed bgedfca
    cdgbf cgedbf cdef baceg ef dfbacg bef egbcf dfeagb bafgcde | gbfce fbdcag fcabgd ef
    fbac efbdga gebdc fc bfegc bgcfead dfcega baecfg afgeb cgf | adcgbef abcgef fcg bacf
    eagdbf de bacfgd abfce dfgab dfabe cfegda bedg fde cebagdf | dfgace cfgdba degb bged
    cefabg bcfgd decbg fdcgeab cdbae ceg bgefcd efgd eg cfgdab | bfgdc fbdcga gce adecb
    ecgabd ebgd gdc fdaegc dbcaf fcegdab acgeb agdcb eabfgc gd | gdbafec efacbdg bgeafc dfacb
    egbfac abg fgeca fgaedc dbfeg cbae acbfgd gefab ba bfcdgea | gab ab efbgca aecbfdg
    eadgcfb ge aegbd cedagf dagfb feabcd abcged dbeca cegb egd | debca fadcbe baedg ge
    cagfeb edabc gd gfdabe cdfg degcfab bgcfa dgbacf gbcda dgb | gd bfeacg afedgb dbaec
    ba bfad febcg decafg fdeac fdgcabe bca abdefc gacbde bcefa | badgce cba eacbf bcafe
    ac cedfa bdecgf dgfea fgbdac dfgabce abce edcfb caefbd fac | gafcbd ecfgbd fbgcde faegd
    bf eafcd caebg fgcb dcfbaeg abf bfaegd cbeagd baefgc acefb | gdbcefa cbeag fab bfa
    gcb ebcgd cfdbaeg dafcge cedfg dgfbce badec begf gb cbgdfa | fgaebdc gbdce gbfe afdcbg
    gfbdc dac bdeagf daebcf gecdaf fcgad geca ca gafed fbcdgae | bafcde dgbfc adebcf gcadf
    ecbgaf cadefb ec debc bgcdaef ace ecafd egdfba aedbf facgd | ec eca efcagb bfaed
    aef fbad ebacg afceb af fedcbg bfced cgadfbe fcbade gaecdf | bgcdef abgce efdbcg aebcg
    cafbde ba cabf agfed ecfbd gfebdac dbeagc abe cbgedf fdbae | abe gdaceb eba bea
    cbdfg ebg edagf be caegbd cbdgfae fgebd cefb cebgdf cbdgfa | bedgca be fbdcge edabcfg
    ebga cbdafg cafgebd eb aedgbf ecfgbd fcaed eafbd bed adgfb | caefd bfdga dcfea cdgabf
    efgdbac ab dgcfb abg afedg faeb dbegfa dacegf bdagf dagcbe | fbcgd gacbdfe cdbgf ab
    ga dbfca acge edfgab gab agfcb cabfge bfdcge dgfeacb efgcb | ag fbecg ag bfcgea
    fdcgbe bad cfbga ceadfb bdeacg bdafc ebdcgaf bcefd da afde | gefdbc daef fade afcdb
    dcagbf cbgef abg ab feagd beagcf cfbegd cbae fegab gdbeacf | gba ebgfa ab fecdgb
    cdbge aefcdb febca feadgb eagdbfc ecbgf gafc gbf ebacfg fg | gf gefbad gf dbecafg
    dgb efdgab becfga aebgc gd cgde cebagd bagcd cebdgaf afbdc | agcbd dg gbd gdec
    dcafebg ebdga degc ecgabd bge dfcgab efabgc feadb gadbc ge | badcg acgedb adebf badge
    aegbfdc fa fagebd dfeac fae eadcgb edgfc bcfa abefcd bdace | fbca ecdbfa agecdfb dcfae
    gbdcea gcfa ecdafbg bagfe bgc ecfdb gecbf fgaedb abfgce cg | dbafge bgaefd edcbf faebg
    cfdegab dbgcfa ebf fe fcaeb fecdba cbage abcfd gfbead cefd | fcbea ef fe bceaf
    dfebga fde bgfd fd gdcbea cebafd dgabe fegad cdeagfb acfge | fgeca cdeabg gdceab fd
    fgeda fcdegb gdbaef dbfcega fad acfeg fgabdc baed da dgfeb | gdefa afd acfge efgbd
    daecbg ace abcgfd dcbegfa efcag dafe ae cbegf gfcda agedcf | aedbgc gacef gadfce egfcb
    dfacb egdac daecgb ceb be begafc edgb cadebfg edcba egfcad | abcegd cfdbage acbdf aegcfbd
    cdfae afgced dbgac fcebad gfdbea badcf fb adcfebg cbef bfd | bafgde begfad bgcda aebfcd
    gace eabdgf gcedf gfaedc efbdc edg ge gacbfed dfcga cfgbda | acge eg dfceg gefbad
    abdcf bdegfa bgedfca ce geafd dfeagc edc aedfc fegc gacdbe | dcfaeg ecd cde aegfbd
    egdbcf agdfbc gacdebf dec gdcfb gebda ec dafebc cgfe dcegb | cfbeadg efgdbc gcebfd ecd
    dafge acefg ecgb cfagdb ebfcagd cgfab ec ecf aedcfb acbefg | becg ec gecbaf adfgbec
    bad dafgc cgebd efbdcg cbedgfa cgabd bfeagd ab dgecba cbea | edcfabg fadcg dba gfcda
    dcefag bcagd ecfag gfacbde fgcaeb cfagb afb efbagd ecfb bf | afdecg ebagdf bcfe fb
    aedgcbf dacefg bfgce dgfebc dbcfag fb cefgd gabce bfc fbed | acgdfb bfegc geabc edgfac
    df aebdgcf gdcba fcbad cbdage bdcagf deagcf fdbg aefbc afd | cdfba df cebfa daf
    edcgf bfeadg bfdea bg gfbed gfba eafcdbg dcfaeb bge degbca | begcda aebfd fbag fedgc
    dbfgaec bcf edcb abfeg egfcb fgbdca gcafed bc bfcdge cdfeg | dgefcba cfgbde ecdgf cb
    eafg gbdaf gcabd fecbda dgebcaf cdfebg adfgbe bgf gf bdfea | gcadb fage gaef afdceb
    debagfc cbdfa gebc cfgaed gc aegfdb cdfebg ebgdf cfg bcdgf | eafbdcg dgfebca deafcg gadefc
    adg abced fbega dg abegcf fgde cfegadb gdabe aegfbd gdbacf | abecd afgbce gdabfc dag
    efacg fagb ebgdfca dfcabe gcdbea fa fbaceg cegfd geacb fca | edgfc fca fa cgeba
    fbadcg caebdg egfbd fdgcb gdbca fbc egdbacf facd fc egcbaf | acdgb egfbca gbceda gfcbd
    adfge bfea fb fagbdc bdf edfbag ecdbg fgbed dbgafce ecgadf | dbefg bdegf aegcdf fdeagc
    ebgdc afecg dcfgeb gbf cfbd dbaecg bf ecbfg agfdecb dbgfea | afgbcde gefbc fb gcebdf
    fga efdab fgdcea bagc fbgcea gfebc abdcegf cbgfde gfbea ga | dgceaf gfa ag cbefg
    gead dfaebgc ag fgcead dacef fdecba adgcf fgcbea cga bgdfc | faced fgbcd bgfeac fagcbe
    bdfaceg gafbcd cfae daebg gecdf edcag cdegfa cga ecbgdf ac | gdeca agc face ac
    dbgcf eg badfe edgbcf gbe aefbgdc eabfcg dgfbac decg fgdeb | cfgbad abdfe eabdf egb
    fcbgad gfcadbe eadb bcadf cfedba bce be fecgd cgabef efdcb | fgcabe ebad edba fdcbga
    df bedgf bcgedf bcaegd dcgf eacbdf ebcdg dfb agedfcb egfab | dcgf fdb edbgc egdacfb
    facdb eca fceagd cfeba dcbe fbcead ec afdbgc acdgbfe begfa | fdeagc ce aec ec
    ecfbad gdabefc edb be bceg abdfg dacgef gbaed cedag cebdga | eb adgfb gcade egcb
    agedbf cegbda abf eafgc fb debafc gaebf eadfbcg begda bgfd | gacfe aegdb gaecf abdeg
    afbced ae efa cdebf ceabf eacgfbd gbafc caed gbefad bedgcf | dbcgfe fae acgbf cfbae
    fbeda cfaebg agbdcf gbaecdf dag gfecda gfabc gd bcgd dafgb | dafbecg dfeba dfaeb gfdcba
    dacfbe dcbfgae abd ba fdgeb cbfa egadcb edabf fdeca geacdf | gcbdaef dbefa bfac dabfe
    cgeafb fdce gafdbc edgca dbacegf efcagd cge baedg gdafc ce | bcfdega ce ec cefd
    db eacgdf bgd gcbad afdcebg fcgbed dfab aebgc dfbcga fcagd | agcdf dbg gafcbd fecagd
    fdge cgd eadfcb gd gbfdc bcfga cbefadg cfbde deabcg gbcefd | dgfe acfebd fbcdg ecdagb
    gcefd fbd db efgdb cbgfea bead cfdbga begfa bfgdeac fgdeba | abcgfd dbf fabge fdb
    efgcd ac eafcbd befagc bdcafeg fegba acgb fca gaefc ebafdg | efcag bagc ca gebafd
    gb bgd bcdag adecb edbfag cdeagbf cfedab acfdg eagdbc cgeb | dcagb acfgedb dbg dbg
    gfdeac gfe fbea bacge bcgafe becgdfa bcgfe ef egcbad fbdcg | bfdgc gcfeba adgceb fge
    bcd dc dgfcba eagcdb cbgafed dgbfe dcebg feacbg cdea acbge | gbefd dbgfac gbdafc adce
    bd dbegf bgd geadbc fgecd afebg fbagcde bgcfde dbfc eacgdf | bd gdb db gcedf
    afdcgb cbeaf bedaf dfbge dab cbdfeag da fdaceb cgebfa deca | egfdb abd fdabce gcfedab
    bcdfaeg afbegc dcbae defb cdaeg dfacbe cbe eb fcgabd abcdf | ebc caedb caedg be
    dgcfeb dbefg ecfgd bge bafecg fgadce eb cdbe degcfba gadbf | be acegdbf cdgfbe abgfd
    ab gfdbae dagfe agdfb bad facgde gfbdc dacfgeb aebg dbfcae | gabe bfgdae caedfb bcgeadf
    cfade agfce ebacdf fde cbdfga bcedfg decfbag dacbf adeb de | fbcda ecafd aefdcb faceg
    gbefda fdaegcb cbdag eacbd cea cefagd dbface efbc dbeaf ce | edbfa faecdb ebcf gdfceab
    fgbead gcdbe ba adfeg bgdae afeb cadgfb bad bcgefda fgedac | cdafbg feagd abdge gcfbade
    cbfe daceb decfag dbefca agdeb bc acfed egfbacd bafdgc cdb | dbc dbfaecg decaf gfcdab
    eafdgc fcdb gbdae cb cgbad feacgb cgadfeb cdfbga abc fgdca | bafcdg cadfge baegd bfcgda
    fabged cfdbea badec abc efadb gacde fdbc cb fbagec eabcgfd | cdaeb cbdea bfaed aebcd
    gbc adfebc ecdagfb ecbgda geca eabdc dbgce edbfg gc abdgcf | gc fegadbc agec gc
    cdgfb cbedag dcgef gcefad ceg adgebf cdeagfb dfgea acfe ce | cdebga ec dcgef ce
    ca gdfba gadcf dfecgb cfadeg eadc afbceg fac dafcgbe decgf | decgf edgfc bgdcafe aecgdf
    abdcge cae bfecg efcdba bfeda gcadfeb ac faebc fgbaed fcad | aebfc ca ca aebcf
    bcafg cafeb eb feadbg fcgade fcdbea dagecfb ecdb abe dfaec | fcegad cbfgeda bcdaegf fcadeb
    becg gfbda gae egfcdab ge deacbf edcfag agcdbe gadeb bcaed | gdabe cegb dcbgae abdce
    adfebc fdbcga gecab gfbdae dg cdfg dbg fcadb bacdg gedcabf | egbac dbfaceg gd dg
    ebcgfd agdbe fabd efcbga cfbgaed dgb fdgeab efgba db acdge | db cgead bgacdfe cgbefd
    dcfbga edbag ae abe fdgbe dgbca aced bfaceg gbacde adfcbge | gefdb cdea cdgba bfdge
    dbgcef acef cbe cbfedga decab acefdb fdbcga ce gbaed dbfac | ce fecabd daebc ebcdgf
    db dcbaf egcfbad fbdeca ebdc egbfad cbagf bfd ecfagd aefdc | dagfbe cdeb cfbead fabcd
    fbagdc gafbc aecbd fbgeac fcabd fdgc afd fd gfbcdea gbeafd | fda eacdb dbegfa dgcf
    dgfeab fabcgd fg fgb cagfb dcgf dcabf cdfaeb fdgcbea bcaeg | adfbc dbgfca bcdafg gfb
    baegc bd daefgc fadgc gfdb cbd ebacfd cdbgaf dgcabef cgbad | daebfcg fcbaed bd cgfabd
    cafbgde cdf fdgae beacd cf adfce cfeg agfcbd fdcaeg gdfaeb | ecdfgba efdca acdbe cdabe
    adfceb bg gdbeafc bgafe fcdbeg fegbca gfdae cafeb cbag beg | egafd efdcba gfacbe bcga
    fbgda cfgbda fgdeb ebag cedbaf edb eb gafecdb gcefd fgbead | eagb dgbfe decafb adfgb
    gefcbd eafdg cdbagef aegfc dg gbfcae dgf aefdb dgac adgcef | dgca feagbc dg agefcd
    dbfeca ebcaf cag gafceb gcabefd bfga ga adgcfe ecdgb aecgb | gdbcafe agc cga afbce
    ecdbfa cebdgaf efdbga bagfc gacbed cd cdfe dbfca ebdaf dac | daebf ecfd dfec cfed
    agcef bf afbced badecg edfgbc efgabdc fegbc cbged fbe bfdg | dgfb fbdeca dagceb gcbed
    daefgb cbaeg cegd gea cfbgad bfcea eg fadecbg bedagc abdcg | aeg ge gefdab ge
    gfbca bac aebcfd dbcfag gdeacf bc gdafc dgbc ebafg ecbgdfa | cba dgcb cbdg eabfdc
    dbegc gacfbd cegfab gabefdc bcgfe ef bfagc feg fdgeab feac | abfdcg afec gdbfea fdgaceb
    bfcea cd cde dcfbeag gabed fegdca fdcb abgecf ebdca fabcde | efbac bfeagc cabdfe cfgabe
    """

func part1(input: String) -> Int {
    let puzzleLines = input.components(separatedBy: .newlines)
    let outputValues = puzzleLines
        .map { $0.components(separatedBy: "| ") }
        .map { $0[1] }
        .map { $0.components(separatedBy: .whitespaces) }
    
//    print(outputValues)

    let counts = outputValues.map { $0.map { $0.count} }
//    print(counts)
    let allCounts = counts.flatMap { $0 }
    let filteredCounts = allCounts.filter { $0 == 2 || $0 == 4 || $0 == 3 || $0 == 7 }
    return filteredCounts.count
}

let exampleInput = """
    be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe
    edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc
    fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg
    fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb
    aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea
    fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb
    dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe
    bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef
    egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb
    gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce
    """

//part1(input: exampleInput) // 26 (correct)
part1(input: puzzleInput) // 310 (correct)
