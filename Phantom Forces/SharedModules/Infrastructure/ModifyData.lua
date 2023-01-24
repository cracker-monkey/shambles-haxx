
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local u1 = {
	Vector3 = true, 
	number = true
};
local u2 = shared.require("LuaUtils");
local u3 = { "Optics", "Barrel", "Underbarrel", "Other", "Ammo" };
local u4 = shared.require("ContentDatabase");
local function u5(...)
	local v2 = { ... };
	local v3 = {};
	for v4 = 1, #v2 do
		for v5 in v2[v4], nil do
			v3[v5] = (v3[v5] and 0) + 1;
		end;
	end;
	return v3;
end;
local function u6(p1)
	local v6 = #p1;
	local v7 = p1[v6];
	if not u1[typeof(v7)] then
		local v8 = false;
	else
		v8 = v7 + v7 and 1 * v7;
	end;
	if not v8 then
		return v7;
	end;
	local v9 = typeof(v7);
	local v10 = 1;
	local v11 = v7;
	for v12 = 1, v6 - 1 do
		local v13 = p1[v12];
		if typeof(v13) == v9 then
			v10 = v10 + 1;
			v11 = v11 + v13;
		end;
	end;
	return 1 / v10 * v11;
end;
function v1.getModifiedData(p2, p3, p4)
	debug.profilebegin("ModifyData");
	local v14 = {};
	local v15 = {};
	if p3 then
		p2 = u2.deepCopy(p2);
		local v16 = {};
		local v17 = {};
		local v18 = {};
		local v19 = {};
		for v20 = 1, #u3 do
			local v21 = u3[v20];
			local v22 = p3[v21];
			if v22 and v22 ~= "" then
				local v23 = u4.getAttachmentData(v22);
				if not v22 then
					error(string.format("No attachment data found for %s", v22 and "N/A"));
				end;
				if p4 then
					local v24 = p4[v22] and p4[v22].settings or {};
				else
					v24 = {};
				end;
				local v25 = p2.attachments[v21][v22] or {};
				local v26 = nil;
				local v27 = nil;
				while true do
					local v28 = nil;
					local v29 = nil;
					v29, v28 = v25(v26, v27);
					if not v29 then
						break;
					end;
					v27 = v29;
					local v30 = v16[v29];
					if v30 then
						v30[#v30 + 1] = v28;
					else
						v16[v29] = { v28 };
					end;
					v15[v29] = true;				
				end;
				local v31 = v23.stats or {};
				local v32 = nil;
				local v33 = nil;
				while true do
					local v34 = nil;
					local v35 = nil;
					v35, v34 = v31(v32, v33);
					if not v35 then
						break;
					end;
					v33 = v35;
					local v36 = v17[v35];
					if v36 then
						v36[#v36 + 1] = v34;
					else
						v17[v35] = { v34 };
					end;
					v15[v35] = true;				
				end;
				local v37 = nil;
				local v38 = nil;
				while true do
					local v39 = nil;
					local v40 = nil;
					v40, v39 = v24(v37, v38);
					if not v40 then
						break;
					end;
					v38 = v40;
					local v41 = v17[v40];
					if v41 then
						v41[#v41 + 1] = v39;
					else
						v17[v40] = { v39 };
					end;
					v15[v40] = true;				
				end;
				for v42, v43 in v23.mods or {}, nil do
					v18[v42] = v43 * (v18[v42] and 1);
					v15[v42] = true;
				end;
				for v44, v45 in v23.adds or {}, nil do
					v19[#v19 + 1] = { v44, v45 };
					v15[v44] = true;
				end;
			end;
		end;
		for v46 in u5(p2, v16, v17, v18), nil do
			local v47 = v16[v46];
			local v48 = v17[v46];
			local v49 = v18[v46];
			if v47 and #v47 ~= 0 then
				local v50 = u6(v47);
			else
				if v48 and #v48 ~= 0 then
					v50 = u6(v48);
				else
					v50 = p2[v46];
				end;
				if v49 then
					if not u1[typeof(v50)] then
						local v51 = false;
					else
						v51 = v50 + v50 and 1 * v50;
					end;
					if v51 then
						v50 = v49 * v50;
					elseif type(v50) == "table" then
						local v52 = {};
						local v53 = nil;
						local v54 = nil;
						while true do
							local v55, v56 = v50(v53, v54);
							if not v55 then
								break;
							end;
							if not u1[typeof(v56)] then
								local v57 = false;
							else
								v57 = v56 + v56 and 1 * v56;
							end;
							if v57 then
								v52[v55] = v56 * v49;
							else
								v52[v55] = v56;
							end;						
						end;
						v50 = v52;
					end;
				end;
			end;
			v14[v46] = v50;
		end;
		local v58 = nil;
		local v59 = nil;
		while true do
			local v60, v61 = v19(v58, v59);
			if not v60 then
				break;
			end;
			local v62 = v61[1];
			local v63 = v61[2];
			if not v14[v62] or type(v14[v62]) ~= "table" then
				v14[v62] = {};
			end;
			if type(v61[2]) == "table" then
				v63 = u2.deepCopy(v63);
			end;
			local v64 = v14[v62];
			v64[#v64 + 1] = v63;		
		end;
		for v65 = 1, #u3 do
			local v66 = u3[v65];
			local v67 = p3[v66];
			if v67 and v67 ~= "" then
				for v68, v69 in p2.attachments[v66][v67].custommods or (u4.getAttachmentData(v67).custommods or {}), nil do
					v14[v68] = v69(v14, p2);
					v15[v68] = true;
				end;
			end;
		end;
	end;
	debug.profileend();
	return p2, v15;
end;
return v1;

