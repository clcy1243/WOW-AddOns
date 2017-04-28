function CritMean(c)
  return 1+c*0.65
end

function dcm(c)
 return  CritMean(c+0.01)/CritMean(c)
end

  function MasteryMean(m,d)
    a = 0
    y ={d}
    x ={d}
  
    for i = 2,12 do
     y[i] = y[i-1] + m
     if y[i]>=1 then   y[i]=1  end
    end
    
    for i = 2,12 do
     x[i] = 1
     for j = 1,i do
      if i==j then x[i] = x[i] * y[i]
        else x[i] = x[i] * (1-y[j])
      end
     end
    end

    for i = 1,12 do
      a = a + i * x[i]
    end
    return a
  end

function dmm(m,d)
  local hm1 = 1 / (1 - 1 / MasteryMean(m,d))
  local hm2 = 1 / (1 - 1 / MasteryMean(m+0.01,d))
  return hm2/hm1
end 

function MasterytThreshold(m,d)
   for i = 12,1,-1 do
     a = (1 - d) / i
     if m < a then return a-m end
   end
  end



SLASH_CritVsMastery1 = "/cvm"
SlashCmdList["CritVsMastery"] = function ()

m = GetMasteryEffect()/100
d = GetDodgeChance()/100-0.045

-- m = 0.30.6  --测试用数据
-- d = 0.-0.045 --测试用数据

 c = GetCritChance()/100
 mt = MasterytThreshold(m,d)
 mm = MasteryMean(m,d)
 print("期望",mm)
 print("等效躲闪：",string.format("%.3f",1 / mm*100),"%")
 print("距离下一个阈值点",string.format("%.3f",mt*100),"%")
 print("精通提升",string.format("%.5f",dmm(m,d)))
 print("精通提升",string.format("%.5f",dmm(m,d+0.1)),"(酒有余香)")
 print("暴击提升",string.format("%.5f",dcm(c)))

 end


