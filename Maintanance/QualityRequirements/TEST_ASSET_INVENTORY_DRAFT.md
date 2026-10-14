# Test Asset Inventory — Draft

> **文書状態:** test整理の判断材料。由来の正本、公開契約、品質適合、削除・採用決定ではない。
>
> **観測日:** 2026-10-14
>
> **観測HEAD:** `5a7eb15`。`Maintanance/User/`のユーザー作業は対象外。

## 1. 目的

現行test資産を、作られた由来と現在観測できる品質上の役割という二軸で整理する。本家由来だから自動的に仕様とはせず、独自・興味由来だから自動的に捨てもしない。

この段階ではfileまたは同じ根拠を持つtest群を単位とする。約8,320行の全test関数へ個別台帳を付けることを目的にしない。

## 2. 実行構造

| 領域 | Package上の位置づけ | 主な役割 | 現在の注意点 |
|---|---|---|---|
| `Tests/AtCoderTests` | `AtCoderTests` test target | core productの単体、internal、death、stress、性能観測、棚卸し | XCTestとSwift Testingが混在する |
| `Tests/ExtraTests` | `ExtraTests` test target | coreとは異なる代替実装の実験 | `AtCoder`へ依存せず、同名型でもcore証拠へ合算できない |
| `Tests/TopLevel` | executable target | package consumerに近いtop-level compile fixture | assertionを持つtestではなく、build成功が観測結果 |
| `Tests/5.8.1` | 現行Package target外 | Swift 5.8.1向けと見られる別source | 製品系列、fixture、配布経路は未確定。現行test結果へ合算しない |

最新の全件実行では230件中192件passed、24件skipped、14件not run、失敗0件だった。件数は品質網羅性を示さず、disabled棚卸しprobeとsource上の無効化testを含む。

## 3. Core module test群

### 内容対応を固定commitと限定照合済みの群

次は既存の暫定モデル試験で、本家commit `864245a00b00dd008d1abfdc239618fdb7d139da` とtest内容の一部または広い範囲を限定照合している。歴史的な移植元まで証明したものではない。

| Test群 | 確認できた由来情報 | 現在の主な役割 | Swift固有または未決の部分 |
|---|---|---|---|
| `segtreeTests.swift` | 本家同名testとの内容対応候補をSegTree試験で確認 | 基本操作、naive比較、追加型構成 | `clone`、operator型、`~Copyable`、無効化されたinvalidとの関係 |
| `deathTests/segTreeDeathTests.swift` | invalid条件の対応候補 | assertによる異常終了のprocess観測 | assertを公開契約にするか、build条件 |
| `dsuTests.swift` | 本家基本testとの対応候補 | 基本統合、line case、groups、性能観測 | `clone`等のSwift追加API |
| `fenwickTreeTests.swift` | 本家testとの広い内容対応を確認 | 基本・境界・overflow・型変換 | internal helper、Swift型、無効化Assign、`clone`不足 |
| `deathTests/fenwickTreeDeathTests.swift` | 本家Invalid条件との対応 | index／range／負のsizeの異常終了 | assert無効構成と公開保証 |
| `sccTests.swift` | Empty、Simple、SelfLoop等の内容対応 | component、順序の実装観測、小規模measure | Practice2由来未確認、順序契約、無効化test |
| `deathTests/sccDeathTests.swift` | 本家Invalidの一条件と対応 | 不正edgeの異常終了 | 他の不正条件とRelease境界 |
| `modintTests.swift` | 多数の同名・同内容test候補を限定照合 | static／dynamic演算、境界、constructor、Numeric | Swift overload、無効化block、stress skip、global state reset |
| `deathTests/modintDeathTests.swift` | negative exponent条件の対応候補 | 異常終了 | inverse等の他事前条件、assert境界 |
| `bitTests.swift` | 本家`bit_test.cpp`の3群とほぼ行単位で対応 | internal bit helperの例と境界 | 本家の最終入力`unsigned int max`がSwiftでは`CInt.max`相当になっている |
| `two_satTests.swift` | Empty、One、Assign、StressOKが本家`twosat_test.cpp`と内容対応 | 基本解、unsatisfiable、randomized satisfiable scenario | AssignはSwift差異として無効化。stressはDEBUGで回数縮小しXCTest `measure`内で実行 |

各群の正確な範囲と証拠限界は、対応する暫定モデル試験を正本とする。

Bitは同じ固定commitの`test/unittest/bit_test.cpp`と追加照合した。`BitCeil`の全入力と、`CountrZero`／`CountrZeroConstexpr`のうち最終入力以外は対応する。本家の最終入力は`std::numeric_limits<unsigned int>::max()`である一方、Swiftは`CInt.max`または`UInt32(CInt.max)`を使う。通常の32-bit C型対応では、本家が`UInt32.max`相当、Swift testが`Int32.max`相当となる。

この差異を埋める棚卸しtest `EtcTests/testInventoryBitCountrZeroAtUInt32Maximum()` を追加し、`UInt32.max`に対する通常版とconstexpr版がともに0を返すことをSwift 6.4で選択実行し、1件成功した。対象wrapperはdeprecatedなので、意図した直接観測で通常buildへ新しい警告を残さないようtest自身もdeprecated contextに置いた。この状態でtest discoveryと再実行成功を確認し、build warningは0件だった。これは現行実装の観測であり、元testの由来説明や対応toolchain全体の保証を自動的に確定しない。

- upstream comparison: `https://raw.githubusercontent.com/atcoder/ac-library/864245a00b00dd008d1abfdc239618fdb7d139da/test/unittest/bit_test.cpp`
- selected summary: `/var/folders/x9/2p70phpx3_xdvwx9s6gp35rm0000gn/T/ActionArtifacts/5BD4E566-73C1-4995-97F0-E905432444B7/RunSomeTests/632A5E6B-9368-40EB-BB40-A9E6559831E8.txt`
- xcresult: `/var/folders/x9/2p70phpx3_xdvwx9s6gp35rm0000gn/T/ActionArtifacts/5BD4E566-73C1-4995-97F0-E905432444B7/RunSomeTests/Test-swift-ac-library-Package-2026.10.14_20-19-26-+0900.xcresult`
- warning-free build log: `/var/folders/x9/2p70phpx3_xdvwx9s6gp35rm0000gn/T/ActionArtifacts/5BD4E566-73C1-4995-97F0-E905432444B7/BuildProject/BuildProject-Log-20261014-201839.txt`

TwoSATも固定commitの`test/unittest/twosat_test.cpp`と追加照合した。EmptyとOneは操作・assertが対応し、AssignはC++の再代入をコメント保持したままSwiftに同じ演算子がないとして`#if false`になっている。Stressは生成方法と検査が対応するが、SwiftはDEBUGでphaseを1,000へ縮小し、全体をXCTest `measure`で囲む。

Stressはrandomized correctnessを観測できる一方、乱数入力生成とassertを測定区間に含み、環境・seed・受入水準も固定していない。したがって現状では外部比較可能な性能証拠とは分類しない。

- upstream comparison: `https://raw.githubusercontent.com/atcoder/ac-library/864245a00b00dd008d1abfdc239618fdb7d139da/test/unittest/twosat_test.cpp`

### 本家対応候補だが、今回まだ固定commit照合していない群

| Test群 | 現在観測できる役割 | 由来の状態 | 棚卸し上の次の扱い |
|---|---|---|---|
| `convolutionTests.swift` | 型別演算、境界、issue再現、stress、measure | 本家issue linkを含むが群全体は未照合 | issue由来、型移植差、性能wrapperを分ける |
| `internalMathTests.swift` | barrett、prime、safe mod、inv gcd、primitive root等のinternal invariant | 未照合 | 2,000行超のため機能群単位で扱う |
| `mathTests.swift` | pow、inverse、CRT、floor sumの公開動作・境界 | 未照合 | C++整数型移植とSwift `Int`追加を分ける |
| `stringTests.swift` | suffix array、LCP、Z algorithm、naive比較、文字型差 | 未照合 | internal algorithm testと公開API型別testを分ける |
| `lazySegtreeTests.swift` | 基本、naive比較、利用例、複数operator型 | 未照合 | 無効化Assign／Invalidとdeath testを接続する |
| `lazySegtreeStressTests.swift` | naive、maxRight、minLeftのstress | 未照合 | correctness stressとXCTest measureを分ける |
| `maxFlowTests.swift` | 基本、cut、複数回、境界、self-loop、stress | 未照合 | 無効化Invalidとdeath test、measureを分ける |
| `mincostflowTests.swift` | 基本、usage、self-loop、same-cost、stress、misc | 本家issue linkを一部含むが未照合 | 無効化Outrange／Invalidとdeath testを接続する |
| 各対応death test | invalid-inputのprocess観測 | 通常fileの無効化testと対応するものがある | 条件ごとに通常testから移管済みか確認する |

これらを一括して「本家由来」と表示しない。固定比較点との内容照合または履歴根拠を得るまでは、対応候補として扱う。

## 4. Swift固有・project固有のtest資産

| Test／support群 | 現在の役割 | 現時点の扱い |
|---|---|---|
| `internalTraitsTests.swift` | `ToUnsignedType`のbit pattern観測 | Swift数値表現に固有。Fenwick等の下位不変条件候補 |
| `etc/internalConvolutionTests.swift` | Swift internal convolutionの補助構造・Int128経路 | public convolution testとは証拠範囲を分ける |
| `etc/SegTreeOperationTests.swift` | closure型operator APIのcompile／構築例と空のmeasure | functional assertionがなく、API availabilityと性能雛形を分ける |
| `TopLevel/main.swift` | top-levelで複数operator定義がcompileできること | consumer compile fixture候補。単体test成功とは別の証拠 |
| `EtcTests.swift` | Fenwick literal、SCC再利用、dynamic ModInt時間的挙動 | 明示的な棚卸し資産。契約決定後に昇格・移動・削除を判断 |
| `DeathTest.swift` | Death Test雛形とSCC再帰境界probe | 850代表probe以外は観測結果付きdisabled。製品上限ではない |
| `etc/etcTests.swift` | bit表現の小観測とskipされた変換性能実験 | 興味・実験由来候補。性能証拠ではない |
| `etc/math.deprecated.swift` | test target内のdeprecated互換helper | testではなくfixture／互換補助source。少なくとも`mathTests.testPowMod()`のC++型別名経路が`CLongLong, CLongLong, CInt` overloadへ依存する。残るgeneric helperの呼出し依存は未確定 |
| `etc/CPPRange.swift` | C++風inclusive range helper | 移植test記述の補助。製品APIではない |
| `etc/segtree_naive.swift` | 本家test fileへの出典コメントを持つnaive oracle | test oracleとしての役割と歴史的由来を区別する |
| `util/math.swift`、`util/random.swift` | testデータ生成・oracle補助 | 製品品質ではなくtest妥当性へ影響するsupport code |
| `util/utilsMathTests.swift` | support math自体の確認 | test oracleの信頼性確認候補。無効化testあり |

## 5. 代替実装・互換source

### ExtraTests

`ExtraTests`は、core `AtCoder` moduleをimportせず、target内にFenwickTreeとweighted DSUの別実装を持つ。

- Fenwick testはrange sum、signed／unsigned wrapping、反復更新、clone独立性を観測する。
- weighted DSU testは差分、root swap、既結合merge、path compression、groups、clone独立性を観測する。

これらは有用な設計実験・scenario資産だが、core implementationの成功証拠ではない。将来coreへ機能を採用する場合は、対象実装と契約を確定してからtestを移植または再記述する。

### Swift 5.8.1 source

`Tests/5.8.1`にはDSU、FenwickTree、SegTree、LazySegTreeの別sourceがあるが、現行manifestのtargetには含まれない。名前が`Tests`配下でも、自動実行されるtestではない。

保守対象、配布source、compile fixture、過去実装のいずれかを決めるまでは、現行製品testにも不要資産にも分類しない。

## 6. 実行状態の棚卸し

### Source上で無効化されている群

少なくともFenwickTree、LazySegTree、SCC、MaxFlow、MinCostFlow、TwoSATのAssign／Invalid等と、ModIntのIncrement・一部境界block、Convolution・InternalMathの一部が`#if false`にある。

主な理由は次に分かれる。

- C++の代入演算子等がSwiftに直接存在しない
- invalid条件をSwift TestingのDeath Testへ移した
- platform／整数型差
- 理由または代替証拠が未整理

無効化testを一律削除せず、対応するDeath TestまたはSwift差異説明があるかを群ごとに確認する。

### Runtime skip

- `etcTests`の性能例6件は常に`XCTSkip`し、現在は性能証拠にならない。
- ModInt stressはDEBUGでskipする。
- Int128関連はavailabilityによりskipし得る。
- disabled SCC probeは過去の成功・`SIGBUS`観測を保持する棚卸し資産である。

skipは成功、not run、source無効化と分ける。

### Invalid testとDeath Testの対応確認

通常fileに残るInvalidの本文と、対応Death Testの条件を現物で照合した。

| 対象 | 通常側の状態 | Death Testとの内容対応 | 現時点の判定 |
|---|---|---|---|
| FenwickTree | `#if false`、6条件をコメント保持 | 負のsize、addの下限・上限、sumの3不正rangeを6件すべて観測 | 通常側記載に対して移管済み |
| LazySegTree | `#if false`、7条件 | 負のsize、get 2件、prod 4件をすべて観測 | 通常側記載に対して移管済み |
| SegTree | source上は有効だが冒頭で常時`XCTSkip`、10条件 | Death Testは10条件を観測。ただし負のsizeは通常側の`segtree_naive`ではなく製品`SegTree`を対象にする | 条件は移管済み。通常側skipを残す意味は別判断 |
| MaxFlow | `#if false`、flowの2条件 | 2条件をすべて観測 | 通常側記載に対して移管済み |
| MinCostFlow Outrange | `#if false`、slopeの2条件 | `testOutOfRange`が2条件を観測 | 通常側記載に対して移管済み |
| MinCostFlow Invalid | `#if false`、negative cap／costの2条件 | `testInvalid`が2条件を観測 | 通常側記載に対して移管済み |
| SCC | `#if false`、to上限違反1条件 | 同じ1条件を観測 | 通常側記載に対して移管済み |

ここでの「移管済み」は、通常側に列挙された条件がDeath Testに存在するという意味だけである。本家Invalid全体の網羅、公開契約への採用、Releaseでの成立は示さない。

通常側の残骸を直ちに削除する必要はない。現在はC++側条件の可読な対応表としても働いているため、由来情報をDeath Test側へ集約できるか、重複を保つかを棚卸し時に決める。

### `measure`を持つ群

DSU、SCC、LazySegTree stress、MaxFlow、MinCostFlow、TwoSAT、Convolution、SegTreeOperation等にXCTest measureがある。小規模caseのwrapper、空の雛形、stress correctnessとの混在があるため、存在だけで性能証拠としない。

## 7. 重複ではなく接続として確認する組合せ

| 組合せ | 棚卸し時の問い |
|---|---|
| 通常fileの無効化Invalid ↔ death test | 条件がすべて移管されたか。元testを説明として残す必要があるか |
| core Fenwick ↔ Extra Fenwick | 別実装のscenarioをcoreへ採用する価値があるか。直接証拠合算は不可 |
| core DSU ↔ weighted DSU | weighted機能を別製品候補として残すか。通常DSUの追加testとはしない |
| module test ↔ `EtcTests`／`DeathTest` | 契約確定後にmodule固有testへ昇格するか、調査資産として残すか |
| unit test ↔ `TopLevel` | runtime動作とconsumer compile可能性のどちらを証明するか |
| public test ↔ internal／naive oracle | 同じ出力でも、公開契約と実装不変条件の証拠範囲を分けられるか |

## 8. 現時点の判断候補

### すぐに削除しない

- 本家対応が未照合というだけのtest
- Swift差異を説明する無効化test
- 別targetの代替実装test
- 棚卸し用probe
- test oracle／support source

### 次の整理で優先して確認する

1. 常時skipの性能雛形が、将来計画、参考実験、削除候補のどれか。
2. `#if false`のInvalidがDeath Testへ完全移管済みか。
3. `SegTreeOperationTests`の空measureとassertを持たないexampleの現在の役割。
4. `math.deprecated.swift`のgeneric `inv_mod`／`crt`と`CLongLong`版`floor_sum`が現行testのcompileに必要か。`pow_mod(CLongLong, CLongLong, CInt)`は`mathTests.testPowMod()`の型から必要と判断できるが、他のhelperはclass内の`Int`別名と製品側の完全一致overloadがあり、解決結果の独立確認まではしていない。
5. `Tests/5.8.1`を何として保守するか。
6. ExtraTestsの機能を製品候補として扱うか、実験保存に留めるか。

### 後で必要な製品判断

- 本家基準版と、差異を許容・説明する単位
- Swift追加APIと代替実装の採否
- performance testとbenchmarkの役割分担
- 互換sourceの提供・保守方針
- disabled／skip testをrelease品質ゲートでどう扱うか

## 9. 現時点の結論

- testの削除・移動: **未実施**
- 由来の全件確定: **未実施**
- 品質証拠への採否: **未実施**
- file／test群単位の初期棚卸し: **レビュー可能**
- 次の安全な作業: 無効化InvalidとDeath Testの対応確認、常時skip／空measure／deprecated fixtureの依存確認
