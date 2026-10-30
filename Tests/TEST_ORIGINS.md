# Test origins

Tests use Swift Testing. `aclPort` identifies ports of the upstream ACL test cases;
`swiftSpecific` identifies Swift API checks, regressions, inventory probes and extra workloads.
The files themselves are separated:

- `AtCoderTests/ACLPort`: upstream-corresponding cases, including exit tests.
- `AtCoderTests/SwiftSpecific`: Swift-specific cases and additional checks.
- `AtCoderTests/Support`: shared helpers without test cases.
- `ExtraTests`: tests for the additional implementations in that target.

Mixed suites use extensions in separate files, retaining their shared setup and
serial execution policy. Tags are supplemental; they do not replace file separation.
Exit tests live beside ordinary tests for the same feature and carry the `exitTest` tag.
Inventory exit probes live in `SwiftSpecific/EtcTests.swift`.

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
| AtCoderTests/ACLPort/dsuTests.swift | test0 | aclPort | dsu_test.cpp :: Zero |
| AtCoderTests/ACLPort/dsuTests.swift | testSimple | aclPort | dsu_test.cpp :: Simple |
| AtCoderTests/ACLPort/dsuTests.swift | testLine | aclPort | dsu_test.cpp :: Line |
| AtCoderTests/ACLPort/dsuTests.swift | testLineReverse | aclPort | dsu_test.cpp :: LineReverse |
| AtCoderTests/SwiftSpecific/dsuTests+Swift.swift | testPerformance | swiftSpecific | — |
| AtCoderTests/SwiftSpecific/dsuTests+Swift.swift | testClone | swiftSpecific | — |
| AtCoderTests/ACLPort/mathTests.swift | testPowMod | aclPort | math_test.cpp :: PowMod |
| AtCoderTests/SwiftSpecific/mathTests+Swift.swift | testPowMod_Int | swiftSpecific | — |
| AtCoderTests/ACLPort/mathTests.swift | testInvBoundHand | aclPort | math_test.cpp :: InvBoundHand |
| AtCoderTests/SwiftSpecific/mathTests+Swift.swift | testInvBoundHand_Int | swiftSpecific | — |
| AtCoderTests/ACLPort/mathTests.swift | testInvMod | aclPort | math_test.cpp :: InvMod |
| AtCoderTests/SwiftSpecific/mathTests+Swift.swift | testInvMod_Int | swiftSpecific | — |
| AtCoderTests/ACLPort/mathTests.swift | testInvModZero | aclPort | math_test.cpp :: InvModZero |
| AtCoderTests/SwiftSpecific/mathTests+Swift.swift | testInvModZero_Int | swiftSpecific | — |
| AtCoderTests/ACLPort/mathTests.swift | testFloorSum | aclPort | math_test.cpp :: FloorSum |
| AtCoderTests/ACLPort/mathTests.swift | testCRTHand | aclPort | math_test.cpp :: CRTHand |
| AtCoderTests/SwiftSpecific/mathTests+Swift.swift | testCRTHand_Int | swiftSpecific | — |
| AtCoderTests/ACLPort/mathTests.swift | testCRT2 | aclPort | math_test.cpp :: CRT2 |
| AtCoderTests/SwiftSpecific/mathTests+Swift.swift | testCRT2_Int | swiftSpecific | — |
| AtCoderTests/ACLPort/mathTests.swift | testCRT3 | aclPort | math_test.cpp :: CRT3 |
| AtCoderTests/SwiftSpecific/mathTests+Swift.swift | testCRT3_Int | swiftSpecific | — |
| AtCoderTests/ACLPort/mathTests.swift | testCRTOverflow | aclPort | math_test.cpp :: CRTOverflow |
| AtCoderTests/SwiftSpecific/mathTests+Swift.swift | testCRTOverflow_Int | swiftSpecific | — |
| AtCoderTests/ACLPort/mathTests.swift | testCRTBound | aclPort | math_test.cpp :: CRTBound |
| AtCoderTests/SwiftSpecific/mathTests+Swift.swift | testCRTBound_Int | swiftSpecific | — |
| AtCoderTests/SwiftSpecific/stringTests+Swift.swift | testSaNaive | swiftSpecific | — |
| AtCoderTests/SwiftSpecific/stringTests+Swift.swift | testSaNaive2 | swiftSpecific | — |
| AtCoderTests/SwiftSpecific/stringTests+Swift.swift | testSaNaive3 | swiftSpecific | — |
| AtCoderTests/ACLPort/stringTests.swift | testEmpty | aclPort | string_test.cpp :: Empty |
| AtCoderTests/ACLPort/stringTests.swift | testSALCPNaive | aclPort | string_test.cpp :: SALCPNaive |
| AtCoderTests/ACLPort/stringTests.swift | testInternalSANaiveNaive | aclPort | string_test.cpp :: InternalSANaiveNaive |
| AtCoderTests/ACLPort/stringTests.swift | testInternalSADoublingNaive | aclPort | string_test.cpp :: InternalSADoublingNaive |
| AtCoderTests/ACLPort/stringTests.swift | testInternalSAISNaive | aclPort | string_test.cpp :: InternalSAISNaive |
| AtCoderTests/ACLPort/stringTests.swift | testSAAllATest | aclPort | string_test.cpp :: SAAllATest |
| AtCoderTests/ACLPort/stringTests.swift | testSAAllABTest | aclPort | string_test.cpp :: SAAllABTest |
| AtCoderTests/ACLPort/stringTests.swift | testSA | aclPort | string_test.cpp :: SA |
| AtCoderTests/SwiftSpecific/stringTests+Swift.swift | testSAFullWidth | swiftSpecific | — |
| AtCoderTests/SwiftSpecific/stringTests+Swift.swift | testSACharacter | swiftSpecific | — |
| AtCoderTests/SwiftSpecific/stringTests+Swift.swift | testSAUInt8 | swiftSpecific | — |
| AtCoderTests/ACLPort/stringTests.swift | testSASingle | aclPort | string_test.cpp :: SASingle |
| AtCoderTests/ACLPort/stringTests.swift | testLCP | aclPort | string_test.cpp :: LCP |
| AtCoderTests/SwiftSpecific/stringTests+Swift.swift | testLCPFullWidth | swiftSpecific | — |
| AtCoderTests/SwiftSpecific/stringTests+Swift.swift | testLCPCharacter | swiftSpecific | — |
| AtCoderTests/SwiftSpecific/stringTests+Swift.swift | testLCPUInt8 | swiftSpecific | — |
| AtCoderTests/ACLPort/stringTests.swift | testZAlgo | aclPort | string_test.cpp :: ZAlgo |
| AtCoderTests/SwiftSpecific/stringTests+Swift.swift | testZAlgoFullWidth | swiftSpecific | — |
| AtCoderTests/SwiftSpecific/stringTests+Swift.swift | testZAlgoCharacter | swiftSpecific | — |
| AtCoderTests/SwiftSpecific/stringTests+Swift.swift | testZAlgoUInt8 | swiftSpecific | — |
| AtCoderTests/ACLPort/stringTests.swift | testZNaive | aclPort | string_test.cpp :: ZNaive |
| AtCoderTests/ACLPort/fenwickTreeTests.swift | testEmpty | aclPort | fenwicktree_test.cpp :: Empty |
| AtCoderTests/ACLPort/fenwickTreeTests.swift | testAssign | aclPort | fenwicktree_test.cpp :: Assign |
| AtCoderTests/ACLPort/fenwickTreeTests.swift | testZero | aclPort | fenwicktree_test.cpp :: Zero |
| AtCoderTests/ACLPort/fenwickTreeTests.swift | testOverFlowULL | aclPort | fenwicktree_test.cpp :: OverFlowULL |
| AtCoderTests/ACLPort/fenwickTreeTests.swift | testNaiveTest | aclPort | fenwicktree_test.cpp :: NaiveTest |
| AtCoderTests/ACLPort/fenwickTreeTests.swift | testSMintTest | aclPort | fenwicktree_test.cpp :: SMintTest |
| AtCoderTests/ACLPort/fenwickTreeTests.swift | testMintTest | aclPort | fenwicktree_test.cpp :: MintTest |
| AtCoderTests/ACLPort/fenwickTreeTests.swift | testInvalid | aclPort | fenwicktree_test.cpp :: Invalid |
| AtCoderTests/ACLPort/fenwickTreeTests.swift | testBound | aclPort | fenwicktree_test.cpp :: Bound |
| AtCoderTests/ACLPort/fenwickTreeTests.swift | testBoundll | aclPort | fenwicktree_test.cpp :: Boundll |
| AtCoderTests/ACLPort/fenwickTreeTests.swift | testOverFlow | aclPort | fenwicktree_test.cpp :: OverFlow |
| AtCoderTests/ACLPort/fenwickTreeTests.swift | testInt128 | aclPort | fenwicktree_test.cpp :: Int128 |
| AtCoderTests/SwiftSpecific/fenwickTreeTests+Swift.swift | testInt | swiftSpecific | — |
| AtCoderTests/SwiftSpecific/fenwickTreeTests+Swift.swift | testSum | swiftSpecific | — |
| AtCoderTests/SwiftSpecific/fenwickTreeTests+Swift.swift | testHandleUnsigned | swiftSpecific | — |
| AtCoderTests/ACLPort/maxFlowTests.swift | test0 | aclPort | maxflow_test.cpp :: Zero |
| AtCoderTests/ACLPort/maxFlowTests.swift | testAssign | aclPort | maxflow_test.cpp :: Assign |
| AtCoderTests/ACLPort/maxFlowTests.swift | testSimple | aclPort | maxflow_test.cpp :: Simple |
| AtCoderTests/ACLPort/maxFlowTests.swift | testNotSimple | aclPort | maxflow_test.cpp :: NotSimple |
| AtCoderTests/ACLPort/maxFlowTests.swift | testCut | aclPort | maxflow_test.cpp :: Cut |
| AtCoderTests/ACLPort/maxFlowTests.swift | testTwice | aclPort | maxflow_test.cpp :: Twice |
| AtCoderTests/ACLPort/maxFlowTests.swift | testBound | aclPort | maxflow_test.cpp :: Bound |
| AtCoderTests/SwiftSpecific/maxFlowTests+Swift.swift | testBoundUnit | swiftSpecific | — |
| AtCoderTests/ACLPort/maxFlowTests.swift | testSelfLoop | aclPort | maxflow_test.cpp :: SelfLoop |
| AtCoderTests/ACLPort/maxFlowTests.swift | testInvalid | aclPort | maxflow_test.cpp :: Invalid |
| AtCoderTests/ACLPort/maxFlowTests.swift | testStress | aclPort | maxflow_test.cpp :: Stress |
| AtCoderTests/ACLPort/convolutionTests.swift | testEmpty | aclPort | convolution_test.cpp :: Empty |
| AtCoderTests/ACLPort/convolutionTests.swift | testMid | aclPort | convolution_test.cpp :: Mid |
| AtCoderTests/ACLPort/convolutionTests.swift | testSimpleSMod | aclPort | convolution_test.cpp :: SimpleSMod |
| AtCoderTests/ACLPort/convolutionTests.swift | testSimpleInt | aclPort | convolution_test.cpp :: SimpleInt |
| AtCoderTests/ACLPort/convolutionTests.swift | testSimpleUint | aclPort | convolution_test.cpp :: SimpleUint |
| AtCoderTests/ACLPort/convolutionTests.swift | testSimpleULL | aclPort | convolution_test.cpp :: SimpleULL |
| AtCoderTests/ACLPort/convolutionTests.swift | testSimpleInt128 | aclPort | convolution_test.cpp :: SimpleInt128 |
| AtCoderTests/ACLPort/convolutionTests.swift | testSimpleUInt128 | aclPort | convolution_test.cpp :: SimpleUInt128 |
| AtCoderTests/ACLPort/convolutionTests.swift | testConvLL | aclPort | convolution_test.cpp :: ConvLL |
| AtCoderTests/ACLPort/convolutionTests.swift | testConvLLBound | aclPort | convolution_test.cpp :: ConvLLBound |
| AtCoderTests/ACLPort/convolutionTests.swift | testConv641 | aclPort | convolution_test.cpp :: Conv641 |
| AtCoderTests/ACLPort/convolutionTests.swift | testConv18433 | aclPort | convolution_test.cpp :: Conv18433 |
| AtCoderTests/ACLPort/convolutionTests.swift | testConv2 | aclPort | convolution_test.cpp :: Conv2 |
| AtCoderTests/ACLPort/convolutionTests.swift | testConv257 | aclPort | convolution_test.cpp :: Conv257 |
| AtCoderTests/ACLPort/convolutionTests.swift | testConv2147483647 | aclPort | convolution_test.cpp :: Conv2147483647 |
| AtCoderTests/ACLPort/convolutionTests.swift | testConv2130706433 | aclPort | convolution_test.cpp :: Conv2130706433 |
| AtCoderTests/SwiftSpecific/convolutionTests+Swift.swift | testInfo_998_244_353 | swiftSpecific | — |
| AtCoderTests/SwiftSpecific/convolutionTests+Swift.swift | testStress0 | swiftSpecific | — |
| AtCoderTests/SwiftSpecific/internalTraitsTests.swift | testHandleUnsigned | swiftSpecific | — |
| AtCoderTests/SwiftSpecific/modintTests+Swift.swift | testModulus | swiftSpecific | — |
| AtCoderTests/ACLPort/modintTests.swift | testDynamicBorder | aclPort | modint_test.cpp :: DynamicBorder |
| AtCoderTests/SwiftSpecific/modintTests+Swift.swift | testDynamicBorderAlt | swiftSpecific | — |
| AtCoderTests/ACLPort/modintTests.swift | testULL | aclPort | modint_test.cpp :: ULL |
| AtCoderTests/ACLPort/modintTests.swift | testMod1 | aclPort | modint_test.cpp :: Mod1 |
| AtCoderTests/ACLPort/modintTests.swift | testModIntMax | aclPort | modint_test.cpp :: ModIntMax |
| AtCoderTests/ACLPort/modintTests.swift | testInt128 | aclPort | modint_test.cpp :: Int128 |
| AtCoderTests/ACLPort/modintTests.swift | testInv | aclPort | modint_test.cpp :: Inv |
| AtCoderTests/ACLPort/modintTests.swift | testConstUsage | aclPort | modint_test.cpp :: ConstUsage |
| AtCoderTests/ACLPort/modintTests.swift | testIncrement | aclPort | modint_test.cpp :: Increment |
| AtCoderTests/ACLPort/modintTests.swift | testStaticUsage | aclPort | modint_test.cpp :: StaticUsage |
| AtCoderTests/ACLPort/modintTests.swift | testDynamicUsage | aclPort | modint_test.cpp :: DynamicUsage |
| AtCoderTests/SwiftSpecific/modintTests+Swift.swift | testDynamicUsage2 | swiftSpecific | — |
| AtCoderTests/ACLPort/modintTests.swift | testConstructor | aclPort | modint_test.cpp :: Constructor |
| AtCoderTests/ACLPort/modintTests.swift | testConstructorStatic | aclPort | modint_test.cpp :: ConstructorStatic |
| AtCoderTests/SwiftSpecific/modintTests+Swift.swift | testSome | swiftSpecific | — |
| AtCoderTests/SwiftSpecific/modintTests+Swift.swift | testUsageStaticWithInt | swiftSpecific | — |
| AtCoderTests/SwiftSpecific/modintTests+Swift.swift | testUsageDynamicWithInt | swiftSpecific | — |
| AtCoderTests/SwiftSpecific/modintTests+Swift.swift | testEtc | swiftSpecific | — |
| AtCoderTests/SwiftSpecific/modintTests+Swift.swift | testEtc2 | swiftSpecific | — |
| AtCoderTests/SwiftSpecific/modintTests+Swift.swift | testNumeric | swiftSpecific | — |
| AtCoderTests/ACLPort/internalMathTests.swift | testBarrett | aclPort | internal_math_test.cpp :: Barrett |
| AtCoderTests/ACLPort/internalMathTests.swift | testBarrettCIntBorder | aclPort | internal_math_test.cpp :: BarrettIntBorder |
| AtCoderTests/ACLPort/internalMathTests.swift | testBarrettCUnsignedIntBorder | aclPort | internal_math_test.cpp :: BarrettUintBorder |
| AtCoderTests/ACLPort/internalMathTests.swift | testIsPrime | aclPort | internal_math_test.cpp :: IsPrime |
| AtCoderTests/ACLPort/internalMathTests.swift | testSafeMod | aclPort | internal_math_test.cpp :: SafeMod |
| AtCoderTests/SwiftSpecific/internalMathTests+Swift.swift | testSafeModAlt | swiftSpecific | — |
| AtCoderTests/ACLPort/internalMathTests.swift | testInvGcdBound | aclPort | internal_math_test.cpp :: InvGcdBound |
| AtCoderTests/SwiftSpecific/internalMathTests+Swift.swift | testInvGcdBound2 | swiftSpecific | — |
| AtCoderTests/SwiftSpecific/internalMathTests+Swift.swift | testInvGcdBoundAlt | swiftSpecific | — |
| AtCoderTests/ACLPort/internalMathTests.swift | testPrimitiveRootTestNaive | aclPort | internal_math_test.cpp :: PrimitiveRootTestNaive |
| AtCoderTests/ACLPort/internalMathTests.swift | testPrimitiveRootTemplateTest | aclPort | internal_math_test.cpp :: PrimitiveRootTemplateTest |
| AtCoderTests/ACLPort/internalMathTests.swift | testPrimitiveRootTest | aclPort | internal_math_test.cpp :: PrimitiveRootTest |
| AtCoderTests/SwiftSpecific/internalMathTests+Swift.swift | testPrimitiveRootTest2 | swiftSpecific | — |
| AtCoderTests/SwiftSpecific/internalMathTests+Swift.swift | testPrimitiveRootTest3 | swiftSpecific | — |
| AtCoderTests/SwiftSpecific/internalMathTests+Swift.swift | testPrimitiveRootIntMaxTest | swiftSpecific | — |
| AtCoderTests/ACLPort/lazySegtreeTests.swift | test0 | aclPort | lazysegtree_test.cpp :: Zero |
| AtCoderTests/ACLPort/lazySegtreeTests.swift | testAssign | aclPort | lazysegtree_test.cpp :: Assign |
| AtCoderTests/ACLPort/lazySegtreeTests.swift | testInvalid | aclPort | lazysegtree_test.cpp :: Invalid |
| AtCoderTests/ACLPort/lazySegtreeTests.swift | testNaiveProd | aclPort | lazysegtree_test.cpp :: NaiveProd |
| AtCoderTests/ACLPort/lazySegtreeTests.swift | testUsage | aclPort | lazysegtree_test.cpp :: Usage |
| AtCoderTests/SwiftSpecific/lazySegtreeTests+Swift.swift | test0_0 | swiftSpecific | — |
| AtCoderTests/SwiftSpecific/lazySegtreeTests+Swift.swift | testNaiveProd_0 | swiftSpecific | — |
| AtCoderTests/SwiftSpecific/lazySegtreeTests+Swift.swift | testUsage_0 | swiftSpecific | — |
| AtCoderTests/SwiftSpecific/convolutionCacheTests.swift | testDistinctTypesWithEqualModulus | swiftSpecific | — |
| AtCoderTests/ACLPort/two_satTests.swift | testEmpty | aclPort | twosat_test.cpp :: Empty |
| AtCoderTests/ACLPort/two_satTests.swift | testOne | aclPort | twosat_test.cpp :: One |
| AtCoderTests/ACLPort/two_satTests.swift | testAssign | aclPort | twosat_test.cpp :: Assign |
| AtCoderTests/ACLPort/two_satTests.swift | testStress | aclPort | twosat_test.cpp :: StressOK |
| AtCoderTests/ACLPort/lazySegtreeStressTests.swift | testStressNaive | aclPort | lazysegtree_stress_test.cpp :: NaiveTest |
| AtCoderTests/ACLPort/lazySegtreeStressTests.swift | testStressMaxRight | aclPort | lazysegtree_stress_test.cpp :: MaxRightTest |
| AtCoderTests/ACLPort/lazySegtreeStressTests.swift | testStressMinLeft | aclPort | lazysegtree_stress_test.cpp :: MinLeftTest |
| AtCoderTests/ACLPort/bitTests.swift | testBitCeil | aclPort | bit_test.cpp :: BitCeil |
| AtCoderTests/ACLPort/bitTests.swift | testCountrZero | aclPort | bit_test.cpp :: CountrZero |
| AtCoderTests/ACLPort/bitTests.swift | testCountrZeroConstexpr | aclPort | bit_test.cpp :: CountrZeroConstexpr |
| AtCoderTests/ACLPort/mincostflowTests.swift | test0 | aclPort | mincostflow_test.cpp :: Zero |
| AtCoderTests/ACLPort/mincostflowTests.swift | testSimple | aclPort | mincostflow_test.cpp :: Simple |
| AtCoderTests/ACLPort/mincostflowTests.swift | testUsage | aclPort | mincostflow_test.cpp :: Usage |
| AtCoderTests/ACLPort/mincostflowTests.swift | testAssign | aclPort | mincostflow_test.cpp :: Assign |
| AtCoderTests/ACLPort/mincostflowTests.swift | testOutrange | aclPort | mincostflow_test.cpp :: OutOfRange |
| AtCoderTests/ACLPort/mincostflowTests.swift | testSelfLoop | aclPort | mincostflow_test.cpp :: SelfLoop |
| AtCoderTests/SwiftSpecific/mincostflowTests+Swift.swift | testSameCostPath | swiftSpecific | — |
| AtCoderTests/ACLPort/mincostflowTests.swift | testInvalid | aclPort | mincostflow_test.cpp :: Invalid |
| AtCoderTests/ACLPort/mincostflowTests.swift | testStress | aclPort | mincostflow_test.cpp :: Stress |
| AtCoderTests/SwiftSpecific/mincostflowTests+Swift.swift | testMisc | swiftSpecific | — |
| AtCoderTests/ACLPort/segtreeTests.swift | test0 | aclPort | segtree_test.cpp :: Zero |
| AtCoderTests/ACLPort/segtreeTests.swift | testInvalid | aclPort | segtree_test.cpp :: Invalid |
| AtCoderTests/ACLPort/segtreeTests.swift | testOne | aclPort | segtree_test.cpp :: One |
| AtCoderTests/ACLPort/segtreeTests.swift | testCompareNaive | aclPort | segtree_test.cpp :: CompareNaive |
| AtCoderTests/SwiftSpecific/segtreeTests+Swift.swift | testClone | swiftSpecific | — |
| AtCoderTests/SwiftSpecific/segtreeTests+Swift.swift | test0_0 | swiftSpecific | — |
| AtCoderTests/SwiftSpecific/segtreeTests+Swift.swift | testOne_0 | swiftSpecific | — |
| AtCoderTests/SwiftSpecific/segtreeTests+Swift.swift | testCompareNaive_0 | swiftSpecific | — |
| AtCoderTests/SwiftSpecific/EtcTests.swift | testInventoryBitCountrZeroAtUInt32Maximum | swiftSpecific | — |
| AtCoderTests/SwiftSpecific/EtcTests.swift | testInventoryFenwickGenericNegativeOneInitializesUnsignedStorageToZero | swiftSpecific | — |
| AtCoderTests/SwiftSpecific/EtcTests.swift | testInventorySCCRepeatedEvaluationAndMutationAfterEvaluation | swiftSpecific | — |
| AtCoderTests/SwiftSpecific/EtcTests.swift | testInventoryDynamicModIntValueAcrossModulusChange | swiftSpecific | — |
| AtCoderTests/ACLPort/sccTests.swift | testEmpty | aclPort | scc_test.cpp :: Empty |
| AtCoderTests/SwiftSpecific/sccTests+Swift.swift | testLongChainAndCycle | swiftSpecific | — |
| AtCoderTests/SwiftSpecific/sccTests+Swift.swift | testBranchReturnOrder | swiftSpecific | — |
| AtCoderTests/ACLPort/sccTests.swift | testAssign | aclPort | scc_test.cpp :: Assign |
| AtCoderTests/ACLPort/sccTests.swift | testSimple | aclPort | scc_test.cpp :: Simple |
| AtCoderTests/ACLPort/sccTests.swift | testSelfLoop | aclPort | scc_test.cpp :: SelfLoop |
| AtCoderTests/SwiftSpecific/sccTests+Swift.swift | testPractice2 | swiftSpecific | — |
| AtCoderTests/ACLPort/sccTests.swift | testInvalid | aclPort | scc_test.cpp :: Invalid |
| AtCoderTests/SwiftSpecific/sccTests+Swift.swift | testPractice2Performanc | swiftSpecific | — |
| AtCoderTests/ACLPort/utilsMathTests.swift | testFactorsTest | aclPort | utils/math_test.cpp :: FactorsTest |
| AtCoderTests/ACLPort/utilsMathTests.swift | testIsPrimitiveRootTest | aclPort | utils/math_test.cpp :: IsPrimitiveRootTest |
| AtCoderTests/SwiftSpecific/SegTreeOperationTests.swift | testExample | swiftSpecific | — |
| AtCoderTests/SwiftSpecific/SegTreeOperationTests.swift | testPerformanceExample | swiftSpecific | — |
| AtCoderTests/SwiftSpecific/LegacyEtcTests.swift | testExample | swiftSpecific | — |
| AtCoderTests/SwiftSpecific/LegacyEtcTests.swift | testPerformanceExample1 | swiftSpecific | — |
| AtCoderTests/SwiftSpecific/LegacyEtcTests.swift | testPerformanceExample2 | swiftSpecific | — |
| AtCoderTests/SwiftSpecific/LegacyEtcTests.swift | testPerformanceExample3 | swiftSpecific | — |
| AtCoderTests/SwiftSpecific/LegacyEtcTests.swift | testPerformanceExample4 | swiftSpecific | — |
| AtCoderTests/SwiftSpecific/LegacyEtcTests.swift | testPerformanceExample5 | swiftSpecific | — |
| AtCoderTests/SwiftSpecific/LegacyEtcTests.swift | testPerformanceExample6 | swiftSpecific | — |
| AtCoderTests/SwiftSpecific/internalConvolutionTests.swift | testFFTINFO | swiftSpecific | — |
| AtCoderTests/SwiftSpecific/internalConvolutionTests.swift | testButterFly | swiftSpecific | — |
| AtCoderTests/SwiftSpecific/internalConvolutionTests.swift | testSimpleInt128 | swiftSpecific | — |
| AtCoderTests/ACLPort/fenwickTreeTests.swift | fenwickTreeDeathTests.testInvalid | aclPort | ACL invalid-input cases |
| AtCoderTests/ACLPort/maxFlowTests.swift | maxflowDeathTests.testInvalid | aclPort | ACL invalid-input cases |
| AtCoderTests/ACLPort/mincostflowTests.swift | mincostflowDeathTests.testInvalid | aclPort | ACL invalid-input cases |
| AtCoderTests/ACLPort/mincostflowTests.swift | mincostflowDeathTests.testOutOfRange | aclPort | ACL invalid-input cases |
| AtCoderTests/ACLPort/modintTests.swift | modintDeathTests.testStaticUsage | aclPort | ACL invalid-input cases |
| AtCoderTests/ACLPort/modintTests.swift | modintDeathTests.testDynamicUsage | aclPort | ACL invalid-input cases |
| AtCoderTests/ACLPort/sccTests.swift | sccDeathTests.testInvalid | aclPort | ACL invalid-input cases |
| AtCoderTests/ACLPort/lazySegtreeTests.swift | lazySegTreeDeathTests.testInvalid | aclPort | ACL invalid-input cases |
| AtCoderTests/ACLPort/segtreeTests.swift | segTreeDeathTests.testInvalid | aclPort | ACL invalid-input cases |

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

## Continuous integration

`.github/workflows/swift.yml` runs independent Linux jobs for Debug and Release
tests, Address Sanitizer and Thread Sanitizer (both configurations), and the
AtCoder DocC build. Pull requests targeting `main` or `compatible/AtCoder/2025`,
pushes to those branches, and manual dispatches run these checks.
Sanitizer failures are not allowed to pass silently; logs are uploaded even on
failure. ASan leak detection is disabled, matching the collections CI, so this is
not a leak-checking job. `TSAN_TEST` excludes the additional weighted DSU implementation and its tests
from TSan builds because they trigger a compiler crash (Invalid bitcast).
Normal and ASan builds retain them. The additional Fenwick tree remains enabled. A successful
serial test run does not establish that shared library state is thread-safe.

Documentation archives are available as workflow artifacts. Only a push to
`main` deploys the generated site to GitHub Pages, after the documentation build
succeeds; test and sanitizer jobs are independent of that deployment.
Set the repository's **Settings → Pages → Build and deployment → Source** to
**GitHub Actions** before the first deployment. The generated module entry is
`https://narumij.github.io/swift-ac-library/documentation/atcoder/`.
PRs and manual runs never deploy documentation.

To build the same static documentation locally:

```sh
swift package -c release --allow-writing-to-directory .build/documentation \
  generate-documentation --target AtCoder \
  --output-path .build/documentation \
  --transform-for-static-hosting --hosting-base-path swift-ac-library
```

TSAN_TEST also temporarily excludes MCFGraph and its corresponding ACL and Swift-specific tests: Linux Swift 6.4.2 Debug+TSan aborts while verifying mincostflow.swift.o (Invalid bitcast). This test-only trait removes that API from the build; normal and ASan builds retain it. Passing the reduced TSan suite does not cover minimum-cost flow.

The ordinary DSU implementation and its ACL/Swift-specific tests are also excluded by TSAN_TEST: the same compiler failure occurs in dsu.swift.o on Linux Swift 6.4.2 and locally on macOS. Normal and ASan builds retain DSU. The reduced TSan suite does not cover either DSU implementation.

ASan CI enables `ASAN_TEST`: `measureRepeated` executes each body once instead of ten times. Input sizes, inner stress loops and assertions are unchanged; no tests are excluded by this trait. Normal tests retain ten measurement iterations. This reduces repeated performance measurement, not sanitizer checks.
