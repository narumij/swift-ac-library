# Test origins

Tests use Swift Testing. `aclPort` identifies ports of the upstream ACL test cases;
`swiftSpecific` identifies Swift API checks, regressions, inventory probes and extra workloads.
Tags distinguish origins even in files sharing the same helper types. Wholly additional
suites live in `AtCoderTests/SwiftSpecific`, `AtCoderTests/etc`, and `ExtraTests`.

Reference: ACL commit `864245a00b00dd008d1abfdc239618fdb7d139da`, `test/unittest`.
This is a correspondence list, not a claim that every upstream case is ported or that
integer widths, iteration counts and language-specific expressions are identical.
Existing DEBUG guards and disabled examples are preserved. In particular, `BoundUnit`
uses signed Int, so it is not classified as the upstream unsigned BoundUint test.
Alternative fixture-based checks and extra Swift overload checks stay in swiftSpecific.

LibraryTests serializes suites that share product caches and the dynamic modulus.
Exit tests run in isolated processes. Existing measurement blocks retain ten repetitions
and print total duration; no performance pass/fail baseline existed in these tests.

| Source file | Test | Origin | Upstream correspondence |
| --- | --- | --- | --- |
| AtCoderTests/dsuTests.swift | test0 | aclPort | dsu_test.cpp :: Zero |
| AtCoderTests/dsuTests.swift | testSimple | aclPort | dsu_test.cpp :: Simple |
| AtCoderTests/dsuTests.swift | testLine | aclPort | dsu_test.cpp :: Line |
| AtCoderTests/dsuTests.swift | testLineReverse | aclPort | dsu_test.cpp :: LineReverse |
| AtCoderTests/dsuTests.swift | testPerformance | swiftSpecific | — |
| AtCoderTests/dsuTests.swift | testClone | swiftSpecific | — |
| AtCoderTests/mathTests.swift | testPowMod | aclPort | math_test.cpp :: PowMod |
| AtCoderTests/mathTests.swift | testPowMod_Int | swiftSpecific | — |
| AtCoderTests/mathTests.swift | testInvBoundHand | aclPort | math_test.cpp :: InvBoundHand |
| AtCoderTests/mathTests.swift | testInvBoundHand_Int | swiftSpecific | — |
| AtCoderTests/mathTests.swift | testInvMod | aclPort | math_test.cpp :: InvMod |
| AtCoderTests/mathTests.swift | testInvMod_Int | swiftSpecific | — |
| AtCoderTests/mathTests.swift | testInvModZero | aclPort | math_test.cpp :: InvModZero |
| AtCoderTests/mathTests.swift | testInvModZero_Int | swiftSpecific | — |
| AtCoderTests/mathTests.swift | testFloorSum | aclPort | math_test.cpp :: FloorSum |
| AtCoderTests/mathTests.swift | testCRTHand | aclPort | math_test.cpp :: CRTHand |
| AtCoderTests/mathTests.swift | testCRTHand_Int | swiftSpecific | — |
| AtCoderTests/mathTests.swift | testCRT2 | aclPort | math_test.cpp :: CRT2 |
| AtCoderTests/mathTests.swift | testCRT2_Int | swiftSpecific | — |
| AtCoderTests/mathTests.swift | testCRT3 | aclPort | math_test.cpp :: CRT3 |
| AtCoderTests/mathTests.swift | testCRT3_Int | swiftSpecific | — |
| AtCoderTests/mathTests.swift | testCRTOverflow | aclPort | math_test.cpp :: CRTOverflow |
| AtCoderTests/mathTests.swift | testCRTOverflow_Int | swiftSpecific | — |
| AtCoderTests/mathTests.swift | testCRTBound | aclPort | math_test.cpp :: CRTBound |
| AtCoderTests/mathTests.swift | testCRTBound_Int | swiftSpecific | — |
| AtCoderTests/stringTests.swift | testSaNaive | swiftSpecific | — |
| AtCoderTests/stringTests.swift | testSaNaive2 | swiftSpecific | — |
| AtCoderTests/stringTests.swift | testSaNaive3 | swiftSpecific | — |
| AtCoderTests/stringTests.swift | testEmpty | aclPort | string_test.cpp :: Empty |
| AtCoderTests/stringTests.swift | testSALCPNaive | aclPort | string_test.cpp :: SALCPNaive |
| AtCoderTests/stringTests.swift | testInternalSANaiveNaive | aclPort | string_test.cpp :: InternalSANaiveNaive |
| AtCoderTests/stringTests.swift | testInternalSADoublingNaive | aclPort | string_test.cpp :: InternalSADoublingNaive |
| AtCoderTests/stringTests.swift | testInternalSAISNaive | aclPort | string_test.cpp :: InternalSAISNaive |
| AtCoderTests/stringTests.swift | testSAAllATest | aclPort | string_test.cpp :: SAAllATest |
| AtCoderTests/stringTests.swift | testSAAllABTest | aclPort | string_test.cpp :: SAAllABTest |
| AtCoderTests/stringTests.swift | testSA | aclPort | string_test.cpp :: SA |
| AtCoderTests/stringTests.swift | testSAFullWidth | swiftSpecific | — |
| AtCoderTests/stringTests.swift | testSACharacter | swiftSpecific | — |
| AtCoderTests/stringTests.swift | testSAUInt8 | swiftSpecific | — |
| AtCoderTests/stringTests.swift | testSASingle | aclPort | string_test.cpp :: SASingle |
| AtCoderTests/stringTests.swift | testLCP | aclPort | string_test.cpp :: LCP |
| AtCoderTests/stringTests.swift | testLCPFullWidth | swiftSpecific | — |
| AtCoderTests/stringTests.swift | testLCPCharacter | swiftSpecific | — |
| AtCoderTests/stringTests.swift | testLCPUInt8 | swiftSpecific | — |
| AtCoderTests/stringTests.swift | testZAlgo | aclPort | string_test.cpp :: ZAlgo |
| AtCoderTests/stringTests.swift | testZAlgoFullWidth | swiftSpecific | — |
| AtCoderTests/stringTests.swift | testZAlgoCharacter | swiftSpecific | — |
| AtCoderTests/stringTests.swift | testZAlgoUInt8 | swiftSpecific | — |
| AtCoderTests/stringTests.swift | testZNaive | aclPort | string_test.cpp :: ZNaive |
| AtCoderTests/fenwickTreeTests.swift | testEmpty | aclPort | fenwicktree_test.cpp :: Empty |
| AtCoderTests/fenwickTreeTests.swift | testAssign | aclPort | fenwicktree_test.cpp :: Assign |
| AtCoderTests/fenwickTreeTests.swift | testZero | aclPort | fenwicktree_test.cpp :: Zero |
| AtCoderTests/fenwickTreeTests.swift | testOverFlowULL | aclPort | fenwicktree_test.cpp :: OverFlowULL |
| AtCoderTests/fenwickTreeTests.swift | testNaiveTest | aclPort | fenwicktree_test.cpp :: NaiveTest |
| AtCoderTests/fenwickTreeTests.swift | testSMintTest | aclPort | fenwicktree_test.cpp :: SMintTest |
| AtCoderTests/fenwickTreeTests.swift | testMintTest | aclPort | fenwicktree_test.cpp :: MintTest |
| AtCoderTests/fenwickTreeTests.swift | testInvalid | aclPort | fenwicktree_test.cpp :: Invalid |
| AtCoderTests/fenwickTreeTests.swift | testBound | aclPort | fenwicktree_test.cpp :: Bound |
| AtCoderTests/fenwickTreeTests.swift | testBoundll | aclPort | fenwicktree_test.cpp :: Boundll |
| AtCoderTests/fenwickTreeTests.swift | testOverFlow | aclPort | fenwicktree_test.cpp :: OverFlow |
| AtCoderTests/fenwickTreeTests.swift | testInt128 | aclPort | fenwicktree_test.cpp :: Int128 |
| AtCoderTests/fenwickTreeTests.swift | testInt | swiftSpecific | — |
| AtCoderTests/fenwickTreeTests.swift | testSum | swiftSpecific | — |
| AtCoderTests/fenwickTreeTests.swift | testHandleUnsigned | swiftSpecific | — |
| AtCoderTests/maxFlowTests.swift | test0 | aclPort | maxflow_test.cpp :: Zero |
| AtCoderTests/maxFlowTests.swift | testAssign | aclPort | maxflow_test.cpp :: Assign |
| AtCoderTests/maxFlowTests.swift | testSimple | aclPort | maxflow_test.cpp :: Simple |
| AtCoderTests/maxFlowTests.swift | testNotSimple | aclPort | maxflow_test.cpp :: NotSimple |
| AtCoderTests/maxFlowTests.swift | testCut | aclPort | maxflow_test.cpp :: Cut |
| AtCoderTests/maxFlowTests.swift | testTwice | aclPort | maxflow_test.cpp :: Twice |
| AtCoderTests/maxFlowTests.swift | testBound | aclPort | maxflow_test.cpp :: Bound |
| AtCoderTests/maxFlowTests.swift | testBoundUnit | swiftSpecific | — |
| AtCoderTests/maxFlowTests.swift | testSelfLoop | aclPort | maxflow_test.cpp :: SelfLoop |
| AtCoderTests/maxFlowTests.swift | testInvalid | aclPort | maxflow_test.cpp :: Invalid |
| AtCoderTests/maxFlowTests.swift | testStress | aclPort | maxflow_test.cpp :: Stress |
| AtCoderTests/convolutionTests.swift | testEmpty | aclPort | convolution_test.cpp :: Empty |
| AtCoderTests/convolutionTests.swift | testMid | aclPort | convolution_test.cpp :: Mid |
| AtCoderTests/convolutionTests.swift | testSimpleSMod | aclPort | convolution_test.cpp :: SimpleSMod |
| AtCoderTests/convolutionTests.swift | testSimpleInt | aclPort | convolution_test.cpp :: SimpleInt |
| AtCoderTests/convolutionTests.swift | testSimpleUint | aclPort | convolution_test.cpp :: SimpleUint |
| AtCoderTests/convolutionTests.swift | testSimpleULL | aclPort | convolution_test.cpp :: SimpleULL |
| AtCoderTests/convolutionTests.swift | testSimpleInt128 | aclPort | convolution_test.cpp :: SimpleInt128 |
| AtCoderTests/convolutionTests.swift | testSimpleUInt128 | aclPort | convolution_test.cpp :: SimpleUInt128 |
| AtCoderTests/convolutionTests.swift | testConvLL | aclPort | convolution_test.cpp :: ConvLL |
| AtCoderTests/convolutionTests.swift | testConvLLBound | aclPort | convolution_test.cpp :: ConvLLBound |
| AtCoderTests/convolutionTests.swift | testConv641 | aclPort | convolution_test.cpp :: Conv641 |
| AtCoderTests/convolutionTests.swift | testConv18433 | aclPort | convolution_test.cpp :: Conv18433 |
| AtCoderTests/convolutionTests.swift | testConv2 | aclPort | convolution_test.cpp :: Conv2 |
| AtCoderTests/convolutionTests.swift | testConv257 | aclPort | convolution_test.cpp :: Conv257 |
| AtCoderTests/convolutionTests.swift | testConv2147483647 | aclPort | convolution_test.cpp :: Conv2147483647 |
| AtCoderTests/convolutionTests.swift | testConv2130706433 | aclPort | convolution_test.cpp :: Conv2130706433 |
| AtCoderTests/convolutionTests.swift | testInfo_998_244_353 | swiftSpecific | — |
| AtCoderTests/convolutionTests.swift | testStress0 | swiftSpecific | — |
| AtCoderTests/SwiftSpecific/internalTraitsTests.swift | testHandleUnsigned | swiftSpecific | — |
| AtCoderTests/modintTests.swift | testModulus | swiftSpecific | — |
| AtCoderTests/modintTests.swift | testDynamicBorder | aclPort | modint_test.cpp :: DynamicBorder |
| AtCoderTests/modintTests.swift | testDynamicBorderAlt | swiftSpecific | — |
| AtCoderTests/modintTests.swift | testULL | aclPort | modint_test.cpp :: ULL |
| AtCoderTests/modintTests.swift | testMod1 | aclPort | modint_test.cpp :: Mod1 |
| AtCoderTests/modintTests.swift | testModIntMax | aclPort | modint_test.cpp :: ModIntMax |
| AtCoderTests/modintTests.swift | testInt128 | aclPort | modint_test.cpp :: Int128 |
| AtCoderTests/modintTests.swift | testInv | aclPort | modint_test.cpp :: Inv |
| AtCoderTests/modintTests.swift | testConstUsage | aclPort | modint_test.cpp :: ConstUsage |
| AtCoderTests/modintTests.swift | testIncrement | aclPort | modint_test.cpp :: Increment |
| AtCoderTests/modintTests.swift | testStaticUsage | aclPort | modint_test.cpp :: StaticUsage |
| AtCoderTests/modintTests.swift | testDynamicUsage | aclPort | modint_test.cpp :: DynamicUsage |
| AtCoderTests/modintTests.swift | testDynamicUsage2 | swiftSpecific | — |
| AtCoderTests/modintTests.swift | testConstructor | aclPort | modint_test.cpp :: Constructor |
| AtCoderTests/modintTests.swift | testConstructorStatic | aclPort | modint_test.cpp :: ConstructorStatic |
| AtCoderTests/modintTests.swift | testSome | swiftSpecific | — |
| AtCoderTests/modintTests.swift | testUsageStaticWithInt | swiftSpecific | — |
| AtCoderTests/modintTests.swift | testUsageDynamicWithInt | swiftSpecific | — |
| AtCoderTests/modintTests.swift | testEtc | swiftSpecific | — |
| AtCoderTests/modintTests.swift | testEtc2 | swiftSpecific | — |
| AtCoderTests/modintTests.swift | testNumeric | swiftSpecific | — |
| AtCoderTests/internalMathTests.swift | testBarrett | aclPort | internal_math_test.cpp :: Barrett |
| AtCoderTests/internalMathTests.swift | testBarrettCIntBorder | aclPort | internal_math_test.cpp :: BarrettIntBorder |
| AtCoderTests/internalMathTests.swift | testBarrettCUnsignedIntBorder | aclPort | internal_math_test.cpp :: BarrettUintBorder |
| AtCoderTests/internalMathTests.swift | testIsPrime | aclPort | internal_math_test.cpp :: IsPrime |
| AtCoderTests/internalMathTests.swift | testSafeMod | aclPort | internal_math_test.cpp :: SafeMod |
| AtCoderTests/internalMathTests.swift | testSafeModAlt | swiftSpecific | — |
| AtCoderTests/internalMathTests.swift | testInvGcdBound | aclPort | internal_math_test.cpp :: InvGcdBound |
| AtCoderTests/internalMathTests.swift | testInvGcdBound2 | swiftSpecific | — |
| AtCoderTests/internalMathTests.swift | testInvGcdBoundAlt | swiftSpecific | — |
| AtCoderTests/internalMathTests.swift | testPrimitiveRootTestNaive | aclPort | internal_math_test.cpp :: PrimitiveRootTestNaive |
| AtCoderTests/internalMathTests.swift | testPrimitiveRootTemplateTest | aclPort | internal_math_test.cpp :: PrimitiveRootTemplateTest |
| AtCoderTests/internalMathTests.swift | testPrimitiveRootTest | aclPort | internal_math_test.cpp :: PrimitiveRootTest |
| AtCoderTests/internalMathTests.swift | testPrimitiveRootTest2 | swiftSpecific | — |
| AtCoderTests/internalMathTests.swift | testPrimitiveRootTest3 | swiftSpecific | — |
| AtCoderTests/internalMathTests.swift | testPrimitiveRootIntMaxTest | swiftSpecific | — |
| AtCoderTests/lazySegtreeTests.swift | test0 | aclPort | lazysegtree_test.cpp :: Zero |
| AtCoderTests/lazySegtreeTests.swift | testAssign | aclPort | lazysegtree_test.cpp :: Assign |
| AtCoderTests/lazySegtreeTests.swift | testInvalid | aclPort | lazysegtree_test.cpp :: Invalid |
| AtCoderTests/lazySegtreeTests.swift | testNaiveProd | aclPort | lazysegtree_test.cpp :: NaiveProd |
| AtCoderTests/lazySegtreeTests.swift | testUsage | aclPort | lazysegtree_test.cpp :: Usage |
| AtCoderTests/lazySegtreeTests.swift | test0_0 | swiftSpecific | — |
| AtCoderTests/lazySegtreeTests.swift | testNaiveProd_0 | swiftSpecific | — |
| AtCoderTests/lazySegtreeTests.swift | testUsage_0 | swiftSpecific | — |
| AtCoderTests/SwiftSpecific/convolutionCacheTests.swift | testDistinctTypesWithEqualModulus | swiftSpecific | — |
| AtCoderTests/two_satTests.swift | testEmpty | aclPort | twosat_test.cpp :: Empty |
| AtCoderTests/two_satTests.swift | testOne | aclPort | twosat_test.cpp :: One |
| AtCoderTests/two_satTests.swift | testAssign | aclPort | twosat_test.cpp :: Assign |
| AtCoderTests/two_satTests.swift | testStress | aclPort | twosat_test.cpp :: StressOK |
| AtCoderTests/lazySegtreeStressTests.swift | testStressNaive | aclPort | lazysegtree_stress_test.cpp :: NaiveTest |
| AtCoderTests/lazySegtreeStressTests.swift | testStressMaxRight | aclPort | lazysegtree_stress_test.cpp :: MaxRightTest |
| AtCoderTests/lazySegtreeStressTests.swift | testStressMinLeft | aclPort | lazysegtree_stress_test.cpp :: MinLeftTest |
| AtCoderTests/bitTests.swift | testBitCeil | aclPort | bit_test.cpp :: BitCeil |
| AtCoderTests/bitTests.swift | testCountrZero | aclPort | bit_test.cpp :: CountrZero |
| AtCoderTests/bitTests.swift | testCountrZeroConstexpr | aclPort | bit_test.cpp :: CountrZeroConstexpr |
| AtCoderTests/mincostflowTests.swift | test0 | aclPort | mincostflow_test.cpp :: Zero |
| AtCoderTests/mincostflowTests.swift | testSimple | aclPort | mincostflow_test.cpp :: Simple |
| AtCoderTests/mincostflowTests.swift | testUsage | aclPort | mincostflow_test.cpp :: Usage |
| AtCoderTests/mincostflowTests.swift | testAssign | aclPort | mincostflow_test.cpp :: Assign |
| AtCoderTests/mincostflowTests.swift | testOutrange | aclPort | mincostflow_test.cpp :: OutOfRange |
| AtCoderTests/mincostflowTests.swift | testSelfLoop | aclPort | mincostflow_test.cpp :: SelfLoop |
| AtCoderTests/mincostflowTests.swift | testSameCostPath | swiftSpecific | — |
| AtCoderTests/mincostflowTests.swift | testInvalid | aclPort | mincostflow_test.cpp :: Invalid |
| AtCoderTests/mincostflowTests.swift | testStress | aclPort | mincostflow_test.cpp :: Stress |
| AtCoderTests/mincostflowTests.swift | testMisc | swiftSpecific | — |
| AtCoderTests/segtreeTests.swift | test0 | aclPort | segtree_test.cpp :: Zero |
| AtCoderTests/segtreeTests.swift | testInvalid | aclPort | segtree_test.cpp :: Invalid |
| AtCoderTests/segtreeTests.swift | testOne | aclPort | segtree_test.cpp :: One |
| AtCoderTests/segtreeTests.swift | testCompareNaive | aclPort | segtree_test.cpp :: CompareNaive |
| AtCoderTests/segtreeTests.swift | testClone | swiftSpecific | — |
| AtCoderTests/segtreeTests.swift | test0_0 | swiftSpecific | — |
| AtCoderTests/segtreeTests.swift | testOne_0 | swiftSpecific | — |
| AtCoderTests/segtreeTests.swift | testCompareNaive_0 | swiftSpecific | — |
| AtCoderTests/SwiftSpecific/EtcTests.swift | testInventoryBitCountrZeroAtUInt32Maximum | swiftSpecific | — |
| AtCoderTests/SwiftSpecific/EtcTests.swift | testInventoryFenwickGenericNegativeOneInitializesUnsignedStorageToZero | swiftSpecific | — |
| AtCoderTests/SwiftSpecific/EtcTests.swift | testInventorySCCRepeatedEvaluationAndMutationAfterEvaluation | swiftSpecific | — |
| AtCoderTests/SwiftSpecific/EtcTests.swift | testInventoryDynamicModIntValueAcrossModulusChange | swiftSpecific | — |
| AtCoderTests/sccTests.swift | testEmpty | aclPort | scc_test.cpp :: Empty |
| AtCoderTests/sccTests.swift | testLongChainAndCycle | swiftSpecific | — |
| AtCoderTests/sccTests.swift | testBranchReturnOrder | swiftSpecific | — |
| AtCoderTests/sccTests.swift | testAssign | aclPort | scc_test.cpp :: Assign |
| AtCoderTests/sccTests.swift | testSimple | aclPort | scc_test.cpp :: Simple |
| AtCoderTests/sccTests.swift | testSelfLoop | aclPort | scc_test.cpp :: SelfLoop |
| AtCoderTests/sccTests.swift | testPractice2 | swiftSpecific | — |
| AtCoderTests/sccTests.swift | testInvalid | aclPort | scc_test.cpp :: Invalid |
| AtCoderTests/sccTests.swift | testPractice2Performanc | swiftSpecific | — |
| AtCoderTests/util/utilsMathTests.swift | testFactorsTest | aclPort | utils/math_test.cpp :: FactorsTest |
| AtCoderTests/util/utilsMathTests.swift | testIsPrimitiveRootTest | aclPort | utils/math_test.cpp :: IsPrimitiveRootTest |
| AtCoderTests/etc/SegTreeOperationTests.swift | testExample | swiftSpecific | — |
| AtCoderTests/etc/SegTreeOperationTests.swift | testPerformanceExample | swiftSpecific | — |
| AtCoderTests/etc/LegacyEtcTests.swift | testExample | swiftSpecific | — |
| AtCoderTests/etc/LegacyEtcTests.swift | testPerformanceExample1 | swiftSpecific | — |
| AtCoderTests/etc/LegacyEtcTests.swift | testPerformanceExample2 | swiftSpecific | — |
| AtCoderTests/etc/LegacyEtcTests.swift | testPerformanceExample3 | swiftSpecific | — |
| AtCoderTests/etc/LegacyEtcTests.swift | testPerformanceExample4 | swiftSpecific | — |
| AtCoderTests/etc/LegacyEtcTests.swift | testPerformanceExample5 | swiftSpecific | — |
| AtCoderTests/etc/LegacyEtcTests.swift | testPerformanceExample6 | swiftSpecific | — |
| AtCoderTests/etc/internalConvolutionTests.swift | testFFTINFO | swiftSpecific | — |
| AtCoderTests/etc/internalConvolutionTests.swift | testButterFly | swiftSpecific | — |
| AtCoderTests/etc/internalConvolutionTests.swift | testSimpleInt128 | swiftSpecific | — |
| AtCoderTests/deathTests/fenwickTreeDeathTests.swift | testInvalid | aclPort | ACL invalid-input cases |
| AtCoderTests/deathTests/maxflowDeathTests.swift | testInvalid | aclPort | ACL invalid-input cases |
| AtCoderTests/deathTests/mincostflowDeathTests.swift | testInvalid | aclPort | ACL invalid-input cases |
| AtCoderTests/deathTests/mincostflowDeathTests.swift | testOutOfRange | aclPort | ACL invalid-input cases |
| AtCoderTests/deathTests/modintDeathTests.swift | testStaticUsage | aclPort | ACL invalid-input cases |
| AtCoderTests/deathTests/modintDeathTests.swift | testDynamicUsage | aclPort | ACL invalid-input cases |
| AtCoderTests/deathTests/sccDeathTests.swift | testInvalid | aclPort | ACL invalid-input cases |
| AtCoderTests/deathTests/lazySegTreeDeathTests.swift | testInvalid | aclPort | ACL invalid-input cases |
| AtCoderTests/deathTests/segTreeDeathTests.swift | testInvalid | aclPort | ACL invalid-input cases |

The entire ExtraTests target is swiftSpecific. InventoryDeathTests is also swiftSpecific.
modintTests.testStress is swiftSpecific (with its existing Debug skip).

## Running tests

```sh
swift test -c debug
swift test -c release
swift test -c release --sanitize address
```

On the tested macOS/Xcode environment, ASan fails in the existing successful-exit
SCC inventory probe: the child aborts with `Interceptors are not working` because
the sanitizer runtime is loaded too late. Preloading via SwiftPM and its test helper
did not resolve this. Ordinary in-process suites pass under ASan, but the entire
ASan run is not green. The successful-exit expectation remains unchanged; no report
is suppressed. Failure-expecting exit tests alone cannot establish sanitizer health
when the child loader itself aborts. This is separate from test framework migration.
