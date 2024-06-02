import XCTest
#if DEBUG
@testable import AtCoder
#else
import AtCoder
#endif

fileprivate typealias uint = CUnsignedInt
fileprivate typealias ll = CLongLong
fileprivate typealias ull = CUnsignedLongLong

fileprivate extension Array where Element: AdditiveArithmetic {
    mutating func resize(_ n: Int) {
        if count > n {
            removeLast(count - n)
        } else {
            reserveCapacity(n)
            for _ in 0..<(n - count) {
                append(.zero)
            }
        }
    }
}

final class internalConvolutionTests: XCTestCase {

#if DEBUG
    func testFFTINFO() throws {
        typealias mint = modint998244353
        let info = _Internal.fft_info<mint.static_mod>()
//        XCTAssertEqual( info.g, 3 )
//        XCTAssertEqual( info.rank2, 23 )
        XCTAssertEqual( info.root, [1, 998244352, 911660635, 372528824, 929031873, 452798380, 922799308, 781712469, 476477967, 166035806, 258648936, 584193783, 63912897, 350007156, 666702199, 968855178, 629671588, 24514907, 996173970, 363395222, 565042129, 733596141, 267099868, 15311432] )
        XCTAssertEqual( info.iroot, [1, 998244352, 86583718, 509520358, 337190230, 87557064, 609441965, 135236158, 304459705, 685443576, 381598368, 335559352, 129292727, 358024708, 814576206, 708402881, 283043518, 3707709, 121392023, 704923114, 950391366, 428961804, 382752275, 469870224] )
        XCTAssertEqual( info.rate2, [911660635, 509520358, 369330050, 332049552, 983190778, 123842337, 238493703, 975955924, 603855026, 856644456, 131300601, 842657263, 730768835, 942482514, 806263778, 151565301, 510815449, 503497456, 743006876, 741047443, 56250497, 867605899] )
        XCTAssertEqual( info.irate2, [86583718, 372528824, 373294451, 645684063, 112220581, 692852209, 155456985, 797128860, 90816748, 860285882, 927414960, 354738543, 109331171, 293255632, 535113200, 308540755, 121186627, 608385704, 438932459, 359477183, 824071951, 103369235] )
        XCTAssertEqual( info.rate3, [372528824, 337190230, 454590761, 816400692, 578227951, 180142363, 83780245, 6597683, 70046822, 623238099, 183021267, 402682409, 631680428, 344509872, 689220186, 365017329, 774342554, 729444058, 102986190, 128751033, 395565204] )
        XCTAssertEqual( info.irate3, [509520358, 929031873, 170256584, 839780419, 282974284, 395914482, 444904435, 72135471, 638914820, 66769500, 771127074, 985925487, 262319669, 262341272, 625870173, 768022760, 859816005, 914661783, 430819711, 272774365, 530924681] )
    }
    
    func testButterFly() throws {
        
        typealias mint = modint998244353
        let aa = [64, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 937240163, 844177527, 312516614, 907986010, 702634021, 730282913, 931923951, 605818204, 641355466, 159687040, 341829885, 438319871, 59099019, 205095211, 954849985, 627156693, 415058905, 409973981, 650539286, 14374892, 768786505, 131911124, 663355508, 632199223, 173280691, 46051172, 762201933, 368055233, 747939028, 334477722, 264383240, 413402747, 584841608, 733861115, 663766633, 250305327, 630189122, 236042422, 952193183, 824963664, 366045132, 334888847, 866333231, 229457850, 983869463, 347705069, 588270374, 583185450, 371087662, 43394370, 793149144, 939145336, 559924484, 656414470, 838557315, 356888889, 392426151, 66320404, 267961442, 295610334, 90258345, 685727741, 154066828, 61004192, 182174378, 588297792, 330562635, 941424244, 648224307, 379494192, 603869647, 46037480, 302949417, 886758349, 84601358, 314327041, 464294843, 359103670, 714969594, 82646597, 245825581, 394914908, 153521122, 434697896, 927192765, 878592788, 542627112, 380920307, 407603456, 912502322, 939008843, 621711858, 792856151, 441310072, 586694289, 324184798, 289986230, 561320374, 769546129, 129921357, 341212160, 81974405, 185617561, 399758327, 46224114, 784159542, 527693515, 299019615, 533760318, 678323534, 164461761, 612559139, 455936488, 2046772, 211342662, 95004224, 611157530, 802328218, 260120844, 247958822, 398063168, 733585656, 763194519, 856531878, 957632147, 895755087, 863288081, 472191018, 62856033, 272650138, 368237972, 783215348, 277671502, 499932017, 283773745, 177073942, 254101364, 342944755, 851056999, 861346155, 884680510, 154640951, 719575195, 216923602, 813754207, 522189519, 102909044, 607540711, 979548514, 408419287, 646356565, 469775353, 480429161, 901273862, 559313830, 386115435, 186822735, 717773708, 508924422, 337341291, 187703924, 293938696, 459885775, 687901750, 11822986, 965539859, 472522138, 556218168, 57745503, 814239093, 274578207, 674380142, 789601849, 304320008, 710028266, 471322563, 801370727, 607930328, 322278801, 460593082, 816938517, 942989681, 338990461, 270526182, 583736505, 73519874, 552238621, 675523569, 177894218, 230814526, 722643257, 994914212]
        let bb = [128, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 98920802, 777315171, 13164392, 676946309, 884361374, 738916207, 443766056, 373961611, 944083871, 461184171, 53272313, 409049160, 915362397, 948485505, 20455549, 192936506, 686163654, 596547278, 760861750, 556756683, 166228906, 517430864, 640048655, 236591087, 763045924, 353396467, 885129620, 523305155, 18370684, 893084933, 206171876, 49897157, 864305575, 964056588, 963433057, 854759258, 866757361, 434321211, 196004335, 830989802, 488109397, 51219260, 32690511, 231131737, 837880243, 488830773, 553932878, 710465568, 152429169, 194132213, 968362347, 121984350, 661472011, 862931855, 828836725, 905518094, 134405509, 363228194, 176678785, 492276659, 87833082, 440933398, 504054226, 322751268, 675493087, 494190129, 557310957, 910411273, 505967696, 821565570, 635016161, 863838846, 92726261, 169407630, 135312500, 336772344, 876260005, 29882008, 804112142, 845815186, 287778787, 444311477, 509413582, 160364112, 767112618, 965553844, 947025095, 510134958, 167254553, 802240020, 563923144, 131486994, 143485097, 34811298, 34187767, 133938780, 948347198, 792072479, 105159422, 979873671, 474939200, 113114735, 644847888, 235198431, 761653268, 358195700, 480813491, 832015449, 441487672, 237382605, 401697077, 312080701, 805307849, 977788806, 49758850, 82881958, 589195195, 944972042, 537060184, 54160484, 624282744, 554478299, 259328148, 113882981, 321298046, 985079963, 220929184, 899323553]

        var a = repeatElement(1, count: 64).map{mint($0)}
        var b = repeatElement(1, count: 128).map{mint($0)}
        let n = CInt(a.count), m = CInt(b.count)
        let z: CInt = _Internal.bit_ceil(CUnsignedInt(n + m - 1))
        a.resize(Int(z))
        _Internal.butterfly(&a)
        b.resize(Int(z))
        _Internal.butterfly(&b)
        
        let ai = a.map{Int($0.val)}
        let bi = b.map{Int($0.val)}
        XCTAssertEqual(a.count, aa.count)
        XCTAssertEqual(ai, aa)
        XCTAssertEqual(b.count, bb.count)
        XCTAssertEqual(bi, bb)
    }
#endif

}
