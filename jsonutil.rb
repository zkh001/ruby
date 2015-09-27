# coding: utf-8

# JSON文字列変換
# 配列，文字列，数値のすべてに対応できているはず
# json_format_クラス名()を定義すれば出力可能になる
def gen_json(obj)
  class_name = (obj.kind_of?(Numeric) ? "Numeric" : obj.class)
  # 関数のメタ呼び出し
  return send("json_format_#{class_name}", obj)
end

# JSONデータのデータのペアの文字列を生成する
# こんな感じ name value => "name:value"
def gen_json_pair(name, value)
  return gen_json(name) << ':' << gen_json(value)
end

# ハッシュ
def json_format_Hash(value)
  return '{' << value.map{|k,v| gen_json_pair(k.to_s, v) }.join(',') << '}'
end

# 配列
def json_format_Array(value)
    # [a1,a2,a3, ...]という[]でくくられた文字列にする
    # 配列の中はさらに，文字列か値またはそれらの配列をとるため再帰させる
    return '[' << value.map{ |e| gen_json(e) }.join(',') << ']'
end

# 文字列
def json_format_String(value); return '"' << value.to_s << '"'; end

# 数値
def json_format_Numeric(value); return value.to_s; end

# 真偽値
def json_format_TrueClass(value); return 'true'; end
def json_format_FalseClass(value); return 'false'; end

# nil
def json_format_NilClass(value); return 'null'; end

# testing

a = [1,2,3]
b = [1,2,"c",'test']
h = {:e => 100, :hey => "no thanks"}
h2 = {:hello => "hello", "hash" => {:bye => "bye"}}
h3 = {:flag => true, 100 => "hundred"}
  
gen_json a     # => "[1,2,3]"
gen_json b     # => "[1,2,\"c\",\"test\"]"
gen_json h     # => "{\"e\":100,\"hey\":\"no thanks\"}"
gen_json h2    # => "{\"hello\":\"hello\",\"hash\":{\"bye\":\"bye\"}}"
gen_json h3    # => "{\"flag\":true,\"100\":\"hundred\"}"
