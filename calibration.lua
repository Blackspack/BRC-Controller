local highRPM = 1843
local lowRPM = 987
local name = ...
local turbine = peripheral.wrap(name)
local lowcom = 0
local highcom = 0
local highfluid	= 0
local lowfluid = 0
local saved = 0
local count = 0
turbine.setActive(true)
turbine.fluidTank().setNominalFlowRate(0)
RPM = turbine.rotor().RPM()
turbine.setCoilEngaged(true)
function start()
	RPM = turbine.rotor().RPM()
	if lowcom == 0 then 
		print("LowRPM Calibration ongoing ".. name)
		calibrationlowRPM()
	elseif highcom == 0 then 
		print("HighRPM Calibration ongoing ".. name)
		calibrationHighRPM()
	elseif highcom == 1 and lowcom == 1 then
		print("Calibration complete ".. name)
		settings.load("/brc/config")
		settings.set(name .. "HR", highfluid)
		settings.set(name .. "LR", lowfluid)
		settings.save("/brc/config")
		sleep(5)
		saved = 1
	end	
end

function calibrationlowRPM()
	print(RPM)
	if RPM*4 <= lowRPM then
		lowfluid = lowfluid + 5000
		sleep(4)
	elseif RPM*2 <= lowRPM then
		lowfluid = lowfluid + 2000
		sleep(2)
	elseif RPM+200 <= lowRPM then
		lowfluid = lowfluid + 1000
		sleep(2)
	elseif RPM+100 <= lowRPM then
		lowfluid = lowfluid + 500
	elseif RPM+50 <= lowRPM then
		lowfluid = lowfluid + 100
	elseif RPM+10 <= lowRPM then
		lowfluid = lowfluid + 50
	elseif RPM+5 <= lowRPM then
		lowfluid = lowfluid + 10
	elseif RPM >= lowRPM*2 then
		lowfluid = lowfluid - 5000
	elseif RPM >= lowRPM+200 then
		lowfluid = lowfluid - 1000
	elseif RPM >= lowRPM+150 then
		lowfluid = lowfluid - 500
	elseif RPM >= lowRPM+100 then
		lowfluid = lowfluid - 250
	elseif RPM >= lowRPM+50 then
		lowfluid = lowfluid - 100
	elseif RPM >= lowRPM+10 then
		lowfluid = lowfluid - 50
	elseif RPM >= lowRPM+5 then
		lowfluid = lowfluid - 10
	end
	if lowfluid <= 0 then 
	lowfluid = 0
	end
	print(lowfluid)
	turbine.fluidTank().setNominalFlowRate(lowfluid)
	if RPM <= lowRPM+5 and RPM >= lowRPM-5 then
		count = count + 1
	elseif count >= 0 then
		count = 0
	end
	if count >= 30 then 
		lowcom = 1
		print("lowRPM pressure is ".. lowfluid)
		sleep(3)
		print("preparing next process")
		sleep(10)
		count = 0
		
	end

end

function calibrationHighRPM()
	print(RPM)
	
	if RPM*4 <= highRPM then
		highfluid = highfluid + 5000
		sleep(8)
	elseif RPM*2 <= highRPM then
		highfluid = highfluid + 2000
		sleep(2)
	elseif RPM+200 <= highRPM then
		highfluid = highfluid + 1000
		sleep(2)
	elseif RPM+100 <= highRPM then
		highfluid = highfluid + 500
	elseif RPM+50 <= highRPM then
		highfluid = highfluid + 100
	elseif RPM+10 <= highRPM then
		highfluid = highfluid + 50
	elseif RPM+5 <= highRPM then
		highfluid = highfluid + 10
	elseif RPM >= highRPM*2 then
		highfluid = highfluid - 5000
	elseif RPM >= highRPM+200 then
		highfluid = highfluid - 1000
	elseif RPM >= highRPM+150 then
		highfluid = highfluid - 500
	elseif RPM >= highRPM+100 then
		highfluid = highfluid - 250
	elseif RPM >= highRPM+50 then
		highfluid = highfluid - 100
	elseif RPM >= highRPM+10 then
		highfluid = highfluid - 50
	elseif RPM >= highRPM+5 then
		highfluid = highfluid - 10
	end
	if highfluid <= 0 then 
	highfluid = 0
	end
	print(highfluid)
	turbine.fluidTank().setNominalFlowRate(highfluid)
	if RPM <= highRPM+5 and RPM >= highRPM-5 then
		count = count + 1
	elseif count >= 0 then
		count = 0
	end
	if count >= 30 then 
		highcom = 1
		print("highRPM pressure is " .. highfluid)
		sleep(3)
		print("preparing next process")
		turbine.fluidTank().setNominalFlowRate(0)
		sleep(10)
		count = 0
	end

end




function Main()
    while true do
		if lowcom == 1 and highcom == 1 and saved == 1 then break end
        start()			
		os.sleep(2)
	end
end


---------------

parallel.waitForAll(Main)
