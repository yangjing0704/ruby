
#读取行
#行首找class module def if while until for,找到就下一行
#找case do..end
require 'time'
require 'set'
Time.at(0)


class RubyFormater

  def initialize 
    @headKeyWord = (%w(class module def if while until for unless)).to_set
    @bodyKeyWord = (%w(case do)).to_set
    @otherKeyWord = (%w(when else elsif)).to_set
    @endKeyWord = 'end'
    @ldakuohao = '{'
    @rdakuohao = '}'
    @space = '                                                                              '
    @spaceNum = 0
    @cleanline=''
  end


  #Todo排除注释
  def doline(linestr)

    @cleanline = linestr.lstrip          #去掉左边空格
    cpcleanline = @cleanline.dup
    cpcleanline.gsub!(/'.+?'/,'')   #去除单引号的内容
    cpcleanline.gsub!(/".+?"/,'')   #去除双引号的内容
    cpcleanline.gsub!(/#.+/,'')     #去除单行注释内容
    cpcleanline.gsub!(/%w\(.+?\)/,'')

    worldlist = cpcleanline.scan(/\w+/)

    return if worldlist.size < 1 && @cleanline == ''        #单词列表是否为空,空就是空行
    return (@spaceNum+=2)-2 if @headKeyWord.include?(worldlist[0])  #第一关单词是否是关键字,是的话空格加2返回

    @spaceNum -= 2 if @endKeyWord == worldlist[-1]    #如果末尾有end,空格-2

    worldlist.each { |word| 
      return (@spaceNum+=2)-2 if @bodyKeyWord.include?(word) 
      return @spaceNum-2 if @otherKeyWord.include?(word)
      }

    if cpcleanline.include?(@ldakuohao)     #是否有左大括号,
      return (cpcleanline.rstrip[-1]!=@rdakuohao)?((@spaceNum+=2)-2):@spaceNum  #左右大括号在同一行就直接返回
    end
    return (@spaceNum-=2)+2 if @cleanline.rstrip[-1]==@rdakuohao
    return @spaceNum
  end
  def getWordList(linestr)
    sp = doline(linestr)
    @cleanline.insert(0,@space[1..sp])  if sp

    return @cleanline
  end

end

def writelines(filename,strarr)
  File.open(filename,"w") do |f|
    strarr.each {|api| f.puts api}
  end
end



if ARGV[0]
  f = RubyFormater.new
  lines =[]
  IO.readlines(ARGV[0],encoding:'utf-8').each do |line| 
    lines.push f.getWordList(line) 
  end
  writelines ARGV[0],lines
else
  p 'no input file'
end

