# 凱旋（ミリオンゴッド神々の凱旋）の出目データに基づくモード判定
# 図柄: 0=0, 1=1, 2=2, 3=3, 4=4, 5=5, 6=6, 7=7, V=V(赤7/GOD)
module DemeMatcher
  REACH = %w[
    007 012 026 032 038 046 04V 075 0V0
    104 110 123 135 168 175 184
    201 223 280 283 2V1
    315 324 344 354 365
    415 423 428 448 481 4V8
    508 510 514 526 543 564 56V 5V0 5V4
    681
    728 753 758 78V
    801 808 821 841 845 850 873 87V 884
    V07 V31 V34
  ].freeze

  CHANCE = {
    "101" => "チャンス目（奇数ハサミ+中0）",
    "303" => "チャンス目（奇数ハサミ+中0）",
    "505" => "チャンス目（奇数ハサミ+中0）",
    "707" => "チャンス目（奇数ハサミ+中0）",
    "100" => "チャンス目（左奇数+0ケツテンパイ）",
    "300" => "チャンス目（左奇数+0ケツテンパイ）",
    "500" => "チャンス目（左奇数+0ケツテンパイ）",
    "V0V" => "チャンス目【Vモード確定】",
    "V2V" => "チャンス目（頻発でVモード示唆）",
    "V4V" => "チャンス目（頻発でVモード示唆）",
    "V6V" => "チャンス目（頻発でVモード示唆）",
    "38V" => "チャンス目（雅）",
    "468" => "チャンス目（ヨーロッパ）",
    "631" => "チャンス目（無罪）",
    "831" => "チャンス目（野菜）",
  }.freeze

  GSTOP_STRONG = {
    "00V" => "G-STOP強チャンス目（0テンパイ+V）",
    "011" => "G-STOP強チャンス目（0+奇数ケツテンパイ）",
    "020" => "G-STOP強チャンス目（0ハサミ+中偶数）",
    "0V7" => "G-STOP強チャンス目（0+V+7）",
  }.freeze

  GSTOP_WEAK = {
    "017" => "G-STOP弱チャンス目（0頭7含み）",
    "01V" => "G-STOP弱チャンス目（0+奇数+V）",
    "022" => "G-STOP弱チャンス目（0+偶数ケツテンパイ）",
  }.freeze

  V_MODE = {
    "V7V" => "【超天国濃厚】Vモード（V7ハサミ）",
    "V8V" => "Vモード示唆（頻発で確定）",
    "V0V" => "【Vモード確定】",
    "V2V" => "Vモード示唆",
    "V4V" => "Vモード示唆",
    "V6V" => "Vモード示唆",
  }.freeze

  CHOUTENOKU = %w[V7V 700].freeze

  TENKOU_SHORT_PLUS = %w[345 567 V1V V3V V5V V00 V77].freeze

  TENKOU_PREP_PLUS = %w[
    131 151 171
    313 353 373
    515 535 575
    717 737 757
    010 030 050 070
    177 377 577
    234 456 678
    727 747 767 787
    701 703 705
  ].freeze

  NICKNAME = {
    "007" => "007（ダブルオーセブン）", "012" => "012（朝イチ目）",
    "026" => "026（お風呂）",         "032" => "032（お札）",
    "038" => "038（大宮）",           "046" => "046（お城）",
    "04V" => "04V（レシーブ）",       "075" => "075（おなご）",
    "0V0" => "0V0（顔文字）",         "104" => "104（天使）",
    "110" => "110（110番）",          "123" => "123（旧朝イチ目）",
    "135" => "135（G-ZONE開始出目）", "168" => "168（いろは）",
    "175" => "175（イナゴ）",         "184" => "184（いわし）",
    "201" => "201（におい）",         "223" => "223（富士山）",
    "280" => "280（ニーハオ）",       "283" => "283（つばさ）",
    "2V1" => "2V1（ニブイチ）",       "315" => "315（最高）",
    "324" => "324（ミズホ）",         "344" => "344（サシシ）",
    "354" => "354（神輿）",           "365" => "365（365日）",
    "415" => "415（よい子）",         "423" => "423（しじみ）",
    "428" => "428（四谷）",           "448" => "448（使者）",
    "481" => "481（支配）",           "4V8" => "4V8（渋谷）",
    "508" => "508（ゴーヤ）",         "510" => "510（GOD）",
    "514" => "514（こいよ）",         "526" => "526（小次郎）",
    "543" => "543（暦）",             "564" => "564（殺し）",
    "56V" => "56V（転ぶ）",           "5V0" => "5V0（ご無礼）",
    "5V4" => "5V4（拳）",             "681" => "681（無敗）",
    "728" => "728（浪速）",           "753" => "753（和み）",
    "758" => "758（名古屋）",         "78V" => "78V（7頭順目）",
    "801" => "801（ハワイ）",         "808" => "808（八百屋）",
    "821" => "821（ハニー）",         "841" => "841（弥生）",
    "845" => "845（ハシゴ）",         "850" => "850（ハチ公）",
    "873" => "873（花見）",           "87V" => "87V（ハナビ）",
    "884" => "884（林）",             "V07" => "V07（ボーナス）",
    "V31" => "V31（Vサイン）",        "V34" => "V34（バーサス）",
    "38V" => "38V（雅）",             "468" => "468（ヨーロッパ）",
    "631" => "631（無罪）",           "831" => "831（野菜）",
    "700" => "700（超天国）",
  }.freeze

  Result = Struct.new(:deme, :category, :level, :description, :nickname, keyword_init: true)

  LEVELS = {
    reach:          { label: "リーチ目",            color: "danger",    priority: 10 },
    v_mode:         { label: "Vモード確定/示唆",    color: "purple",    priority: 9  },
    choutenoku:     { label: "超天国濃厚",           color: "warning",   priority: 8  },
    tenkou_short:   { label: "天国ショート以上濃厚", color: "warning",   priority: 7  },
    tenkou_prep:    { label: "天国準備以上濃厚",     color: "info",      priority: 6  },
    gstop_strong:   { label: "G-STOP強チャンス目",   color: "success",   priority: 5  },
    chance:         { label: "チャンス目",           color: "success",   priority: 4  },
    gstop_weak:     { label: "G-STOP弱チャンス目",   color: "secondary", priority: 3  },
    normal:         { label: "通常目",               color: "light",     priority: 1  },
  }.freeze

  def self.match(input)
    deme = input.gsub(/[^0-9V]/, "").upcase
    return nil if deme.length != 3
    results = []

    results << Result.new(deme: deme, category: :reach, level: LEVELS[:reach],
      description: "GG当選濃厚！", nickname: NICKNAME[deme] || deme) if REACH.include?(deme)

    results << Result.new(deme: deme, category: :chance, level: LEVELS[:chance],
      description: CHANCE[deme], nickname: NICKNAME[deme]) if CHANCE.key?(deme)

    results << Result.new(deme: deme, category: :gstop_strong, level: LEVELS[:gstop_strong],
      description: GSTOP_STRONG[deme], nickname: NICKNAME[deme]) if GSTOP_STRONG.key?(deme)

    results << Result.new(deme: deme, category: :gstop_weak, level: LEVELS[:gstop_weak],
      description: GSTOP_WEAK[deme], nickname: NICKNAME[deme]) if GSTOP_WEAK.key?(deme)

    results << Result.new(deme: deme, category: :choutenoku, level: LEVELS[:choutenoku],
      description: "超天国濃厚！", nickname: NICKNAME[deme]) if CHOUTENOKU.include?(deme)

    results << Result.new(deme: deme, category: :tenkou_short, level: LEVELS[:tenkou_short],
      description: "天国ショート以上濃厚（ハズレ成立時）", nickname: NICKNAME[deme]) if TENKOU_SHORT_PLUS.include?(deme)

    results << Result.new(deme: deme, category: :tenkou_prep, level: LEVELS[:tenkou_prep],
      description: "天国準備以上濃厚", nickname: NICKNAME[deme]) if TENKOU_PREP_PLUS.include?(deme)

    if V_MODE.key?(deme) && !results.any? { |r| r.category == :reach || r.category == :chance }
      results << Result.new(deme: deme, category: :v_mode, level: LEVELS[:v_mode],
        description: V_MODE[deme], nickname: NICKNAME[deme])
    end

    results << Result.new(deme: deme, category: :normal, level: LEVELS[:normal],
      description: "通常目（特定示唆なし）", nickname: nil) if results.empty?

    results.max_by { |r| r.level[:priority] }
  end
end
