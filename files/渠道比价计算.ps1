# 渠道比价计算脚本 —— 将 数据.md 中所有价格折算为 “元 / 1M tokens”
# 可调假设：汇率 $fx、典型负载权重 ($wIn/$wC/$wO)
# 运行：pwsh -File 渠道比价计算.ps1  （输出 markdown 明细表）

$fx  = 7.2            # 1 USD = ? CNY
$wIn = 0.2            # 典型负载：未命中缓存输入 20%
$wC  = 0.7            # 典型负载：命中缓存输入 70%
$wO  = 0.1            # 典型负载：输出 10%

$rows = New-Object System.Collections.Generic.List[object]

function F([double]$v) {
    if ($v -ge 10)   { return ('{0:F2}' -f $v) }
    if ($v -ge 1)    { return ('{0:F3}' -f $v) }
    if ($v -ge 0.01) { return ('{0:F4}' -f $v) }
    return ('{0:F5}' -f $v)
}

function Add-Row {
    param($Model, $Channel, [double]$Pin, [double]$Pc, [double]$Pout,
          [double]$BPin, [double]$BPc, [double]$BPout, $Note)
    $blend = $wIn*$Pin + $wC*$Pc + $wO*$Pout
    $base  = $wIn*$BPin + $wC*$BPc + $wO*$BPout
    [void]$rows.Add([pscustomobject]@{
        SortKey = $blend
        模型 = $Model; 渠道 = $Channel
        未命中输入 = (F $Pin); 命中缓存 = (F $Pc); 输出 = (F $Pout)
        综合参考 = (F $blend); 相对牌价 = ('{0:P0}' -f ($blend/$base)); 备注 = $Note
    })
}

# ---------- 订阅套餐“额度倍数” = 月费 / 包含额度（越小越便宜，前提：额度用满） ----------
$ccPlans = [ordered]@{
    'Command Code Go  \$1/\$10（无API：返回 upgrade_required）' = 1/10
    'Command Code GOAT \$10/\$70' = 10/70
    'Command Code Pro \$20/\$80'  = 20/80
    'Command Code Max20x \$200/\$300' = 200/300
}
$ocPlans = [ordered]@{
    'OpenCode Go \$10（月限\$60）' = 10/60
    'OpenCode Zen 按量'           = 1.0
}

# ---------- 1) MiMo ----------
# Credit 费率：Credits / token（表头即 “Token”）；1M tokens 消耗 = 费率*1e6 Credits
$mimoPlanTiers = [ordered]@{
    'Lite ¥39'     = 39/4.1e9
    'Standard ¥99' = 99/11e9
    'Pro ¥329'     = 329/38e9
    'Max ¥659'     = 659/82e9
}
function MiMo-Plan([double]$rC, [double]$rIn, [double]$rOut, [double]$f, [double]$k) {
    # 返回 1M tokens 的 (in, cache, out) 元价；$k 为叠加系数（夜间0.8 / 首购0.88）
    return @( ($rIn*1e6*$f*$k), ($rC*1e6*$f*$k), ($rOut*1e6*$f*$k) )
}

$mimoCC = @{   # Command Code / OpenCode 标价（$/1M）: in, cacheRead, out
    'MiMo V2.6 Pro'   = @(0.435, 0.0036, 0.87)
    'MiMo V2.6 Flash' = @(0.14,  0.0028, 0.28)
}

foreach ($m in @('MiMo V2.6 Pro','MiMo V2.6 Flash')) {
    if ($m -eq 'MiMo V2.6 Pro') { $dom = @(3.0, 0.025, 6.0); $rate = @(2.5, 300, 600) }
    else                        { $dom = @(1.0, 0.02,  2.0); $rate = @(2.0, 100, 200) }
    $n = $mimoCC[$m]
    # 牌价基准 = 官方 API 海外定价（$0.435/$0.87 等）x 汇率；CC/OC 标价与此一致
    $bIn = $n[0]*$fx; $bC = $n[1]*$fx; $bOut = $n[2]*$fx
    Add-Row $m '小米官方 API 海外价（牌价基准）' $bIn $bC $bOut $bIn $bC $bOut ('$' + $n[0] + ' / $' + $n[2] + ' 每 1M')
    Add-Row $m '小米官方 API 国内价（数据.md）' $dom[0] $dom[1] $dom[2] $bIn $bC $bOut '人民币标价，约折基准 96-99%'
    foreach ($t in $mimoPlanTiers.GetEnumerator()) {
        $p = MiMo-Plan $rate[0] $rate[1] $rate[2] $t.Value 1.0
        Add-Row $m ("小米 Plan " + $t.Key) $p[0] $p[1] $p[2] $bIn $bC $bOut 'Credit 按 Credits/token；额度当月有效'
    }
    $p = MiMo-Plan $rate[0] $rate[1] $rate[2] $mimoPlanTiers['Max ¥659'] 0.8
    Add-Row $m '小米 Plan Max + 夜间0.8x' $p[0] $p[1] $p[2] $bIn $bC $bOut '0:00-8:00'
    $p = MiMo-Plan $rate[0] $rate[1] $rate[2] $mimoPlanTiers['Max ¥659'] (0.8*0.88)
    Add-Row $m '小米 Plan Max + 夜间 + 首购88折' $p[0] $p[1] $p[2] $bIn $bC $bOut '优惠不叠加时的上限情形'
    Add-Row $m '小米拉新300抵扣金（成本¥45）' ($dom[0]*45/300) ($dom[1]*45/300) ($dom[2]*45/300) $bIn $bC $bOut '拉新活动，0.15x 牌价；面值口径存疑'
    Add-Row $m '小米拉新300抵扣金（成本¥50）' ($dom[0]*50/300) ($dom[1]*50/300) ($dom[2]*50/300) $bIn $bC $bOut '拉新活动，0.167x 牌价；面值口径存疑'
    $n = $mimoCC[$m]
    foreach ($pl in $ccPlans.GetEnumerator()) {
        Add-Row $m $pl.Key ($n[0]*$fx*$pl.Value) ($n[1]*$fx*$pl.Value) ($n[2]*$fx*$pl.Value) $bIn $bC $bOut ('标价 = 官方海外价 $' + $n[0] + '/$' + $n[2])
    }
    foreach ($pl in $ocPlans.GetEnumerator()) {
        Add-Row $m $pl.Key ($n[0]*$fx*$pl.Value) ($n[1]*$fx*$pl.Value) ($n[2]*$fx*$pl.Value) $bIn $bC $bOut ('标价同 CC；Zen=按量')
    }
}

# ---------- 2) DeepSeek ----------
$dsCC = @{
    'DeepSeek V4 Pro'   = @(0.66, 0.022, 1.98)
    'DeepSeek V4 Flash' = @(0.15, 0.003, 0.60)
}
$dsBase = @{
    'DeepSeek V4 Pro'   = @(9.0, 0.30, 27.0)   # 高峰为牌价基准
    'DeepSeek V4 Flash' = @(2.0, 0.04,  8.0)
}
foreach ($m in @('DeepSeek V4 Pro','DeepSeek V4 Flash')) {
    $b = $dsBase[$m]
    Add-Row $m 'DeepSeek 官方 API 高峰' $b[0] $b[1] $b[2] $b[0] $b[1] $b[2] '牌价基准（工作日白天）'
    Add-Row $m 'DeepSeek 官方 API 空闲' ($b[0]/2) ($b[1]/2) ($b[2]/2) $b[0] $b[1] $b[2] '高峰价 50%'
    $n = $dsCC[$m]
    foreach ($pl in $ccPlans.GetEnumerator()) {
        Add-Row $m $pl.Key ($n[0]*$fx*$pl.Value) ($n[1]*$fx*$pl.Value) ($n[2]*$fx*$pl.Value) $b[0] $b[1] $b[2] 'CC/OC 标价为 Off-Peak；Peak x2'
    }
    foreach ($pl in $ocPlans.GetEnumerator()) {
        Add-Row $m $pl.Key ($n[0]*$fx*$pl.Value) ($n[1]*$fx*$pl.Value) ($n[2]*$fx*$pl.Value) $b[0] $b[1] $b[2] 'OC 标价为 Off-Peak'
    }
}

# ---------- 3) GLM ----------
# 积分消耗 = (输入*In + 缓存*Cache + 输出*Out)/10000 -> 每 1M tokens = 100*系数
$glmPlanTiers = [ordered]@{
    'Lite ¥118' = 118/(10000*(52/12))
    'Pro ¥538'  = 538/(60000*(52/12))
    'Max ¥1078' = 1078/(140000*(52/12))
}
$glmCoef = @{
    'GLM-5.3'      = @(6.9, 1.7, 24)    # in, cache, out
    'GLM-5.3-Flash'= @(2.3, 0.56, 8)
}
$glmBase = @{
    'GLM-5.3'       = @(8.0, 2.0,  28.0)
    'GLM-5.3-Flash' = @(0.8, 0.23, 2.8)
    'GLM-5.3-FlashX'= @(2.0, 0.57, 7.0)
}
$glmCC = @{
    'GLM-5.3'       = @(1.40, 0.26, 4.40)
    'GLM-5.3-Flash' = @(0.15, 0.03, 0.50)
}
foreach ($m in @('GLM-5.3','GLM-5.3-Flash')) {
    $b = $glmBase[$m]; $c = $glmCoef[$m]
    Add-Row $m '智谱官方 API' $b[0] $b[1] $b[2] $b[0] $b[1] $b[2] '牌价基准'
    foreach ($t in $glmPlanTiers.GetEnumerator()) {
        $pp = $t.Value
        Add-Row $m ("智谱 Plan " + $t.Key) (100*$c[0]*$pp) (100*$c[1]*$pp) (100*$c[2]*$pp) $b[0] $b[1] $b[2] '已核实：积分 7 天刷新、不累积'
    }
    $pp = $glmPlanTiers['Max ¥1078'] * 0.7
    Add-Row $m '智谱 Plan Max + 连续包年7折' (100*$c[0]*$pp) (100*$c[1]*$pp) (100*$c[2]*$pp) $b[0] $b[1] $b[2] '包季另有8折'
    $n = $glmCC[$m]
    foreach ($pl in $ccPlans.GetEnumerator()) {
        Add-Row $m $pl.Key ($n[0]*$fx*$pl.Value) ($n[1]*$fx*$pl.Value) ($n[2]*$fx*$pl.Value) $b[0] $b[1] $b[2] 'CC 标价为智谱 API 的 1.26-1.35x'
    }
    foreach ($pl in $ocPlans.GetEnumerator()) {
        Add-Row $m $pl.Key ($n[0]*$fx*$pl.Value) ($n[1]*$fx*$pl.Value) ($n[2]*$fx*$pl.Value) $b[0] $b[1] $b[2] 'OC 标价同 CC'
    }
}
$b = $glmBase['GLM-5.3-FlashX']
Add-Row 'GLM-5.3-FlashX' '智谱官方 API' $b[0] $b[1] $b[2] $b[0] $b[1] $b[2] '唯一渠道（Plan/聚合站均无）'

# ---------- 4) StepFun ----------
# 消耗：1 元 = 1,000,000 Credit -> 名义面值 = Credits/1e6 元
$stepPlanTiers = [ordered]@{
    'Plan Flash Mini 月付 ¥49'   = 49/400
    'Plan Flash Plus 月付 ¥99'   = 99/1600
    'Plan Flash Pro 月付 ¥199'   = 199/8000
    'Plan Flash Max 月付 ¥699'   = 699/40000
    'Plan Flash Max 年付 ¥555/月'= (6666/12)/40000
    '首登15天400M Credit（海鲜市场¥4）' = 4/400
    '首登15天400M Credit（海鲜市场¥6）' = 6/400
}
$stepBase = @{
    'Step 5 Preview'  = @(7.0,  0.35, 20.0)
    'Step 3.7 Flash'  = @(1.35, 0.27, 8.1)
}
$stepCC = @{
    'Step 5 Preview' = @(1.00, 0.05, 2.70)
    'Step 3.7 Flash' = @(0.20, 0.04, 1.15)
}
foreach ($m in @('Step 5 Preview','Step 3.7 Flash')) {
    $b = $stepBase[$m]
    Add-Row $m 'StepFun 官方 API' $b[0] $b[1] $b[2] $b[0] $b[1] $b[2] '牌价基准'
    foreach ($t in $stepPlanTiers.GetEnumerator()) {
        Add-Row $m ('StepFun ' + $t.Key) ($b[0]*$t.Value) ($b[1]*$t.Value) ($b[2]*$t.Value) $b[0] $b[1] $b[2] '已核实：1M Credit=¥1，月末清零不结转'
    }
    $n = $stepCC[$m]
    foreach ($pl in $ccPlans.GetEnumerator()) {
        Add-Row $m $pl.Key ($n[0]*$fx*$pl.Value) ($n[1]*$fx*$pl.Value) ($n[2]*$fx*$pl.Value) $b[0] $b[1] $b[2] 'StepFun 仅上架 Command Code，OpenCode 无'
    }
}

# ---------- 5) GPT / Muse ----------
$other = @(
    @{M='GPT-5.6 Sol';       CC=@(5.00, 0.50, 30.00); OC=$null; Chan='Command Code（需 Pro 及以上，闭源）'}
    @{M='GPT-6 Luna';        CC=@(0.10, 0.01,  0.50); OC=@(0.20, 0.02, 1.20); Chan='Command Code / OpenCode Zen（OC 记作 GPT 5.6 Luna ≤272K）'}
    @{M='Muse Spark 1.3';    CC=@(1.25, 0.15,  4.25); OC=$null; Chan='Command Code（需 Pro 及以上，闭源）'}
    @{M='Muse Contributor';  CC=@(0.10, 0.002, 0.20); OC=@(0.10, 0.002, 0.20); Chan='Command Code / OpenCode'}
)
foreach ($o in $other) {
    $n = $o.CC
    $bIn = $n[0]*$fx; $bC = $n[1]*$fx; $bOut = $n[2]*$fx
    Add-Row $o.M '聚合站标价（基准）' $bIn $bC $bOut $bIn $bC $bOut $o.Chan
    foreach ($pl in $ccPlans.GetEnumerator()) {
        Add-Row $o.M $pl.Key ($bIn*$pl.Value) ($bC*$pl.Value) ($bOut*$pl.Value) $bIn $bC $bOut '闭源模型需 Pro 及以上套餐'
    }
    if ($o.OC) {
        $m2 = $o.OC
        foreach ($pl in $ocPlans.GetEnumerator()) {
            Add-Row $o.M $pl.Key ($m2[0]*$fx*$pl.Value) ($m2[1]*$fx*$pl.Value) ($m2[2]*$fx*$pl.Value) $bIn $bC $bOut 'OC 标价可能高于 CC'
        }
    }
}

# ---------- 输出 ----------
$modelOrder = @('MiMo V2.6 Pro','MiMo V2.6 Flash','DeepSeek V4 Pro','DeepSeek V4 Flash',
                'GLM-5.3','GLM-5.3-Flash','GLM-5.3-FlashX','Step 5 Preview','Step 3.7 Flash',
                'GPT-5.6 Sol','GPT-6 Luna','Muse Spark 1.3','Muse Contributor')

$sb = New-Object System.Text.StringBuilder
[void]$sb.AppendLine("# 比价明细（元 / 1M tokens；综合参考价 = 0.2x未命中输入 + 0.7x命中缓存 + 0.1x输出）")
[void]$sb.AppendLine()
[void]$sb.AppendLine("汇率假设：1 USD = $fx CNY。相对牌价 = 综合参考价 / 该模型官方按量牌价综合值。")
foreach ($m in $modelOrder) {
    [void]$sb.AppendLine()
    [void]$sb.AppendLine("## $m")
    [void]$sb.AppendLine()
    [void]$sb.AppendLine('| 渠道 | 未命中输入 | 命中缓存 | 输出 | 综合参考 | 相对牌价 | 备注 |')
    [void]$sb.AppendLine('| :--- | ---: | ---: | ---: | ---: | ---: | :--- |')
    $list = $rows | Where-Object { $_.模型 -eq $m } | Sort-Object SortKey
    foreach ($r in $list) {
        [void]$sb.AppendLine("| $($r.渠道) | $($r.未命中输入) | $($r.命中缓存) | $($r.输出) | $($r.综合参考) | $($r.相对牌价) | $($r.备注) |")
    }
}
$outDir = if ($PSScriptRoot) { $PSScriptRoot } else { (Get-Location).Path }
$sb.ToString() | Out-File -FilePath (Join-Path $outDir '计算明细表.md') -Encoding utf8
Write-Host "已生成 计算明细表.md"
