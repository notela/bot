local function modadd(msg)
    -- superuser and admins only (because sudo are always has privilege)
    if not is_admin(msg) then
        return '_You are not bot admin_'
    end
    local data = load_data(_config.moderation.data)
  if data[tostring(msg.chat_id_)] then
   return '_Group is already added_'
  end
        -- create data array in moderation.json
      data[tostring(msg.chat_id_)] = {
              owners = {},
      mods ={},
      banned ={},
      is_silent_users ={},
      settings = {
          lock_link = 'yes',
          lock_tag = 'no',
          lock_spam = 'yes',
          lock_webpage = 'no',
          lock_markdown = 'no',
          flood = 'yes',
          lock_bots = 'yes',
		  lock_hash = 'no',
		  lock_pmhash = 'no'
          },
   mutes = {
                  mute_fwd = 'no',
                  mute_audio = 'no',
                  mute_video = 'no',
                  mute_contact = 'no',
                  mute_text = 'no',
                  mute_photos = 'no',
                  mute_gif = 'no',
                  mute_loc = 'no',
                  mute_doc = 'no',
                  mute_sticker = 'no',
                  mute_voice = 'no',
                   mute_all = 'no'
          }
      }
  save_data(_config.moderation.data, data)
      local groups = 'groups'
      if not data[tostring(groups)] then
        data[tostring(groups)] = {}
        save_data(_config.moderation.data, data)
      end
      data[tostring(groups)][tostring(msg.chat_id_)] = msg.chat_id_
      save_data(_config.moderation.data, data)
  return '*Group has been added*'
end

local function modrem(msg)
    -- superuser and admins only (because sudo are always has privilege)
      if not is_admin(msg) then
        return '_You are not bot admin_'
    end
    local data = load_data(_config.moderation.data)
    local receiver = msg.chat_id_
  if not data[tostring(msg.chat_id_)] then
    return '_Group is not added_'
  end

  data[tostring(msg.chat_id_)] = nil
  save_data(_config.moderation.data, data)
     local groups = 'groups'
      if not data[tostring(groups)] then
        data[tostring(groups)] = nil
        save_data(_config.moderation.data, data)
      end data[tostring(groups)][tostring(msg.chat_id_)] = nil
      save_data(_config.moderation.data, data)
  return '*Group has been removed*'
end

local function modlist(msg)
    local data = load_data(_config.moderation.data)
    local i = 1
  if not data[tostring(msg.chat_id_)] then
    return "_Group is not added_"
  end
  -- determine if table is empty
  if next(data[tostring(msg.chat_id_)]['mods']) == nil then --fix way
    return "_No_ *Moderator* _in this group_"
  end
  local message = '*List of moderators :*\n'
  for k,v in pairs(data[tostring(msg.chat_id_)]['mods']) do
    message = message ..'`'..i.. '`- '..v..' [_' ..k.. '_] \n'
   i = i + 1
end
  return message
end

local function ownerlist(msg)
    local data = load_data(_config.moderation.data)
    local i = 1
  if not data[tostring(msg.chat_id_)] then
    return "_Group is not added_"
  end
  -- determine if table is empty
  if next(data[tostring(msg.chat_id_)]['owners']) == nil then --fix way
    return "_No_ *Owner* _in this group_"
  end
  local message = '*List of group owners :*\n'
  for k,v in pairs(data[tostring(msg.chat_id_)]['owners']) do
    message = message ..'1'..i.. '`- '..v..' [_' ..k.. '_] \n'
   i = i + 1
end
  return message
end

local function action_by_reply(arg, data)
local cmd = arg.cmd
    local administration = load_data(_config.moderation.data)
if not tonumber(data.sender_user_id_) then return false end
  if not administration[tostring(data.chat_id_)] then
    return tdcli.sendMessage(data.chat_id_, "", 0, "_Group is not added_", 0, "md")
  end
if cmd == "setowner" then
local function owner_cb(arg, data)
    local administration = load_data(_config.moderation.data)
if data.username_ and not data.username_:match("_") then
user_name = '@'..data.username_
else
user_name = data.first_name_
end
if administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." `"..data.id_.."` _is already a_ *Group Owner*", 0, "md")
   end
administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] = user_name
    save_data(_config.moderation.data, administration)
  return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." `"..data.id_.."` _is now the_ *Group Owner*", 0, "md")
end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, owner_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
    if cmd == "promote" then
local function promote_cb(arg, data)
    local administration = load_data(_config.moderation.data)
if data.username_ and not data.username_:match("_") then
user_name = '@'..data.username_
else
user_name = data.first_name_
end
if administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." `"..data.id_.."` _is already a_ *Moderator*", 0, "md")
   end
administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] = user_name
    save_data(_config.moderation.data, administration)
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." `"..data.id_.."` _has been_ *Promoted*", 0, "md")
end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, promote_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
     if cmd == "remowner" then
local function rem_owner_cb(arg, data)
    local administration = load_data(_config.moderation.data)
if data.username_ and not data.username_:match("_") then
user_name = '@'..data.username_
else
user_name = data.first_name_
end
if not administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] then
return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." `"..data.id_.."` _is not a_ *Group Owner*", 0, "md")
   end
administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] = nil
    save_data(_config.moderation.data, administration)
return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." `"..data.id_.."` _is no longer a_ *Group Owner*", 0, "md")
end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, rem_owner_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
    if cmd == "demote" then
local function demote_cb(arg, data)
    local administration = load_data(_config.moderation.data)
if data.username_ and not data.username_:match("_") then
user_name = '@'..data.username_
else
user_name = data.first_name_
end
if not administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." `"..data.id_.."` _is not a_ *Moderator*", 0, "md")
   end
administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] = nil
    save_data(_config.moderation.data, administration)
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." `"..data.id_.."` _has been_ *Demoted*", 0, "md")
end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, demote_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
    if cmd == "id" then
local function id_cb(arg, data)
    return tdcli.sendMessage(arg.chat_id, "", 0, "*"..data.id_.."*", 0, "md")
end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, id_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
end

local function action_by_username(arg, data)
local cmd = arg.cmd
    local administration = load_data(_config.moderation.data)
  if not administration[tostring(arg.chat_id)] then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_Group is not added_", 0, "md")
  end
  if arg.username then
if data.type_.user_.username_ and not data.type_.user_.username_:match("_") then
user_name = '@'..data.type_.user_.username_
else
user_name = data.title_
end
if not arg.username then return false end
if cmd == "setowner" then
if administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." `"..data.id_.."` _is already a_ *Group Owner*", 0, "md")
   end
administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] = user_name
    save_data(_config.moderation.data, administration)
  return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." `"..data.id_.."` _is now the_ *Group Owner*", 0, "md")
  end
  if cmd == "promote" then
if administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." `"..data.id_.."` _is already a_ *Moderator*", 0, "md")
   end
administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] = user_name
    save_data(_config.moderation.data, administration)
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." `"..data.id_.."` _has been_ *Promoted*", 0, "md")
end
   if cmd == "remowner" then
if not administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] then
return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." `"..data.id_.."` _is not a_ *Group Owner*", 0, "md")
   end
administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] = nil
    save_data(_config.moderation.data, administration)
return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." `"..data.id_.."` _is no longer a_ *Group Owner*", 0, "md")
end
   if cmd == "demote" then
if not administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." `"..data.id_.."` _is not a_ *Moderator*", 0, "md")
   end
administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] = nil
    save_data(_config.moderation.data, administration)
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." `"..data.id_.."` _has been_ *Demoted*", 0, "md")
end
   if cmd == "id" then
    return tdcli.sendMessage(arg.chat_id, "", 0, "*"..data.id_.."*", 0, "md")
end
    if cmd == "res" then
    --local text = "<b>ℹ️Information</b> [ @".. data.type_.user_.username_ .." ]: \n<b>✨Name:</b> <i>".. data.title_ .."</i>\n<b>✨ID:</b> [ <code>".. data.id_ .."</code> ]"
       return tdcli.sendMessage(arg.chat_id, 0, 1, "<b>ℹ️Information</b> [ @".. data.type_.user_.username_ .." ]: \n<b>✨Name:</b> <i>".. data.title_ .."</i>\n<b>✨ID:</b> [ <code>".. data.id_ .."</code> ]", 1, 'html')
   end
   else
     return tdcli.sendMessage(arg.chat_id, "", 0, "_User not found!_", 0, "md")
   end
end

local function action_by_id(arg, data)
local cmd = arg.cmd
    local administration = load_data(_config.moderation.data)
  if not administration[tostring(arg.chat_id)] then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_Group is not added_", 1, "md")
  end
if not tonumber(arg.user_id) then return false end
if data.first_name_ then
if data.username_ and not data.username_:match("_") then
user_name = '@'..data.username_
else
user_name = data.first_name_
end
if cmd == "setowner" then
if administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." `"..data.id_.."` _is already a_ *Group Owner*", 0, "md")
   end
administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] = user_name
    save_data(_config.moderation.data, administration)
  return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." `"..data.id_.."` _is now the_ *Group Owner*", 0, "md")
  end
  if cmd == "promote" then
if administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." `"..data.id_.."` _is already a_ *Moderator*", 0, "md")
   end
administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] = user_name
    save_data(_config.moderation.data, administration)
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." `"..data.id_.."` _has been_ *Promoted*", 0, "md")
end
   if cmd == "remowner" then
if not administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] then
return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." `"..data.id_.."` _is not a_ *Group Owner*", 0, "md")
   end
administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] = nil
    save_data(_config.moderation.data, administration)
return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." `"..data.id_.."` _is no longer a_ *Group Owner*", 0, "md")
end
   if cmd == "demote" then
if not administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." `"..data.id_.."` _is not a_ *Moderator*", 0, "md")
   end
administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] = nil
    save_data(_config.moderation.data, administration)
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." `"..data.id_.."` _has been_ *Demoted*", 0, "md")
end
    if cmd == "uid" then
	if data.username_ then
		username = '@'..data.username_
	else
		username = 'not found'
	end
       return tdcli.sendMessage(arg.chat_id, 0, 1, '<b>ℹ️Information</b> [ <code>'..data.id_..'</code> ]: \n<b>✨Name:</b> <i>'..data.first_name_..'</i>\n<b>✨Username:</b> '..username..'', 1, 'html')
	end
	else
  return tdcli.sendMessage(arg.chat_id, "", 0, "_User not found!_", 0, "md")
  end
end


---------------Lock Link-------------------
local function lock_link(msg, data, target) 
if not is_mod(msg) then
 return "*You're Not a* _Moderator_"
end

local lock_link = data[tostring(target)]["settings"]["lock_link"] 
if lock_link == "yes" then
 return "*Link Is Already* `Locked`"
else
 data[tostring(target)]["settings"]["lock_link"] = "yes"
save_data(_config.moderation.data, data) 
 return "*Link Has Been* `Locked`"
end
end

local function unlock_link(msg, data, target)
 if not is_mod(msg) then
return "*You're Not a* _Moderator_"
end 
local lock_link = data[tostring(target)]["settings"]["lock_link"]
 if lock_link == "no" then
return "*Link Is Not* `Locked`" 
else 
data[tostring(target)]["settings"]["lock_link"] = "no" save_data(_config.moderation.data, data) 
return "*Link Has Been* `Unlocked`" 
end
end

---------------Lock Tag-------------------
local function lock_tag(msg, data, target) 
if not is_mod(msg) then
 return "*You're Not a* _Moderator_"
end

local lock_tag = data[tostring(target)]["settings"]["lock_tag"] 
if lock_tag == "yes" then
 return "*Tag Is Already* `Locked`"
else
 data[tostring(target)]["settings"]["lock_tag"] = "yes"
save_data(_config.moderation.data, data) 
 return "*Tag Has Been* `Locked`"
end
end

local function unlock_tag(msg, data, target)
 if not is_mod(msg) then
return "*You're Not a* _Moderator_"
end 
local lock_tag = data[tostring(target)]["settings"]["lock_tag"]
 if lock_tag == "no" then
return "*Tag Is Not* `Locked`" 
else 
data[tostring(target)]["settings"]["lock_tag"] = "no" 
save_data(_config.moderation.data, data) 
return "*Tag Has Been* `Unlocked`" 
end
end

---------------Lock HashTag-------------------
local function lock_hash(msg, data, target) 
if not is_mod(msg) then
 return "*You're Not a* _Moderator_"
end

local lock_tag = data[tostring(target)]["settings"]["lock_hash"] 
if lock_tag == "yes" then
 return "*HashTag Is Already* `Locked`"
else
 data[tostring(target)]["settings"]["lock_hash"] = "yes"
save_data(_config.moderation.data, data) 
 return "*HashTag Has Been* `Locked`"
end
end

local function unlock_hash(msg, data, target)
 if not is_mod(msg) then
return "*You're Not a* _Moderator_"
end 
local lock_tag = data[tostring(target)]["settings"]["lock_hash"]
 if lock_tag == "no" then
return "*HashTag Is Not* `Locked`" 
else 
data[tostring(target)]["settings"]["lock_hash"] = "no" 
save_data(_config.moderation.data, data) 
return "*HashTag Has Been* `Unlocked`" 
end
end

---------------Lock PM HashTag-------------------
local function lock_pmhash(msg, data, target) 
if not is_mod(msg) then
 return "*You're Not a* _Moderator_"
end

local lock_tag = data[tostring(target)]["settings"]["lock_pmhash"] 
if lock_tag == "yes" then
 return "*HashTag Warning Is Already* `Show`"
else
 data[tostring(target)]["settings"]["lock_pmhash"] = "yes"
save_data(_config.moderation.data, data) 
 return "*HashTag Warning Has Been* `Show`"
end
end

local function unlock_pmhash(msg, data, target)
 if not is_mod(msg) then
return "*You're Not a* _Moderator_"
end 
local lock_tag = data[tostring(target)]["settings"]["lock_pmhash"]
 if lock_tag == "no" then
return "*HashTag Warning Is Not* `Show`" 
else 
data[tostring(target)]["settings"]["lock_pmhash"] = "no" 
save_data(_config.moderation.data, data) 
return "*HashTag Warning Has Been* `Hidden`" 
end
end

---------------Lock Mention-------------------
local function lock_mention(msg, data, target) 
if not is_mod(msg) then
 return "*You're Not a* _Moderator_"
end

local lock_mention = data[tostring(target)]["settings"]["lock_mention"] 
if lock_mention == "yes" then
 return "*Mention Is Already* `Locked`"
else
 data[tostring(target)]["settings"]["lock_mention"] = "yes"
save_data(_config.moderation.data, data) 
 return "*Mention Has Been* `Locked`"
end
end

local function unlock_mention(msg, data, target)
 if not is_mod(msg) then
return "*You're Not a* _Moderator_"
end 
local lock_mention = data[tostring(target)]["settings"]["lock_mention"]
 if lock_mention == "no" then
return "*Mention Is Not* `Locked`" 
else 
data[tostring(target)]["settings"]["lock_mention"] = "no" save_data(_config.moderation.data, data) 
return "*Mention Has Been* `Unlocked`" 
end
end

---------------Lock Edit-------------------
local function lock_edit(msg, data, target) 
if not is_mod(msg) then
 return "*You're Not a* _Moderator_"
end

local lock_edit = data[tostring(target)]["settings"]["lock_edit"] 
if lock_edit == "yes" then
 return "*Editing Is Already* `Locked`"
else
 data[tostring(target)]["settings"]["lock_edit"] = "yes"
save_data(_config.moderation.data, data) 
 return "*Editing Has Been* `Locked`"
end
end

local function unlock_edit(msg, data, target)
 if not is_mod(msg) then
return "*You're Not a* _Moderator_"
end 
local lock_edit = data[tostring(target)]["settings"]["lock_edit"]
 if lock_edit == "no" then
return "*Editing Is Not* `Locked`" 
else 
data[tostring(target)]["settings"]["lock_edit"] = "no" save_data(_config.moderation.data, data) 
return "*Editing Has Been* `Unlocked`" 
end
end

---------------Lock spam-------------------
local function lock_spam(msg, data, target) 
if not is_mod(msg) then
 return "*You're Not a* _Moderator_"
end

local lock_spam = data[tostring(target)]["settings"]["lock_spam"] 
if lock_spam == "yes" then
 return "*Spam Is Already* `Locked`"
else
 data[tostring(target)]["settings"]["lock_spam"] = "yes"
save_data(_config.moderation.data, data) 
 return "*Spam Has Been* `Locked`"
end
end

local function unlock_spam(msg, data, target)
 if not is_mod(msg) then
return "*You're Not a* _Moderator_"
end 
local lock_spam = data[tostring(target)]["settings"]["lock_spam"]
 if lock_spam == "no" then
return "*Spam Is Not* `Locked`" 
else 
data[tostring(target)]["settings"]["lock_spam"] = "no" save_data(_config.moderation.data, data) 
return "*Spam Has Been* `Unlocked`" 
end
end

---------------Lock Flood-------------------
local function lock_flood(msg, data, target) 
if not is_mod(msg) then
 return "*You're Not a* _Moderator_"
end

local lock_flood = data[tostring(target)]["settings"]["flood"] 
if lock_flood == "yes" then
 return "*Flooding Is Already* `Locked`"
else
 data[tostring(target)]["settings"]["flood"] = "yes"
save_data(_config.moderation.data, data) 
 return "*Flooding Has Been* `Locked`"
end
end

local function unlock_flood(msg, data, target)
 if not is_mod(msg) then
return "*You're Not a* _Moderator_"
end 
local lock_flood = data[tostring(target)]["settings"]["flood"]
 if lock_flood == "no" then
return "*Flooding Is Not* `Locked`" 
else 
data[tostring(target)]["settings"]["flood"] = "no" save_data(_config.moderation.data, data) 
return "*Flooding Has Been* `Unlocked`" 
end
end

---------------Lock Bots-------------------
local function lock_bots(msg, data, target) 
if not is_mod(msg) then
 return "*You're Not a* _Moderator_"
end

local lock_bots = data[tostring(target)]["settings"]["lock_bots"] 
if lock_bots == "yes" then
 return "*Bots Remove Is Already* `Enabled`"
else
 data[tostring(target)]["settings"]["lock_bots"] = "yes"
save_data(_config.moderation.data, data) 
 return "*Bots Remove Has Been* `Enabled`"
end
end

local function unlock_bots(msg, data, target)
 if not is_mod(msg) then
return "*You're Not a* _Moderator_"
end 
local lock_bots = data[tostring(target)]["settings"]["lock_bots"]
 if lock_bots == "no" then
return "*Bots Remove Is Not* `Enabled`" 
else 
data[tostring(target)]["settings"]["lock_bots"] = "no" save_data(_config.moderation.data, data) 
return "*Bots Remove Has Been* `Disabled`" 
end
end

---------------Lock Markdown-------------------
local function lock_markdown(msg, data, target) 
if not is_mod(msg) then
 return "*You're Not a* _Moderator_"
end

local lock_markdown = data[tostring(target)]["settings"]["lock_markdown"] 
if lock_markdown == "yes" then
 return "*Markdown Is Already* `Locked`"
else
 data[tostring(target)]["settings"]["lock_markdown"] = "yes"
save_data(_config.moderation.data, data) 
 return "*Markdown Has Been* `Locked`"
end
end

local function unlock_markdown(msg, data, target)
 if not is_mod(msg) then
return "*You're Not a* _Moderator_"
end 
local lock_markdown = data[tostring(target)]["settings"]["lock_markdown"]
 if lock_markdown == "no" then
return "*Markdown Is Not* `Locked`" 
else 
data[tostring(target)]["settings"]["lock_markdown"] = "no" save_data(_config.moderation.data, data) 
return "*Markdown Has Been* `Unlocked`" 
end
end

---------------Lock Webpage-------------------
local function lock_webpage(msg, data, target) 
if not is_mod(msg) then
 return "*You're Not a* _Moderator_"
end

local lock_webpage = data[tostring(target)]["settings"]["lock_webpage"] 
if lock_webpage == "yes" then
 return "*Webpage Is Already* `Locked`"
else
 data[tostring(target)]["settings"]["lock_webpage"] = "yes"
save_data(_config.moderation.data, data) 
 return "*Webpage Has Been* `Locked`"
end
end

local function unlock_webpage(msg, data, target)
 if not is_mod(msg) then
return "*You're Not a* _Moderator_"
end 
local lock_webpage = data[tostring(target)]["settings"]["lock_webpage"]
 if lock_webpage == "no" then
return "*Webpage Is Not* `Locked`" 
else 
data[tostring(target)]["settings"]["lock_webpage"] = "no"
save_data(_config.moderation.data, data) 
return "*Webpage Has Been* `Unlocked`" 
end
end

-------------------Settings------------------
function group_settings(msg, target) 	
if not is_mod(msg) then
 	return "You're Not Moderator"	
end
local data = load_data(_config.moderation.data)
local target = msg.chat_id_ 
if data[tostring(target)] then 	
if data[tostring(target)]["settings"]["num_msg_max"] then 	
NUM_MSG_MAX = tonumber(data[tostring(target)]['settings']['num_msg_max'])
	print('custom'..NUM_MSG_MAX) 	
else 	
NUM_MSG_MAX = 5
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_link"] then			
data[tostring(target)]["settings"]["lock_link"] = "yes"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_tag"] then			
data[tostring(target)]["settings"]["lock_tag"] = "yes"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_hash"] then			
data[tostring(target)]["settings"]["lock_hash"] = "no"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_pmhash"] then			
data[tostring(target)]["settings"]["lock_pmhash"] = "no"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_mention"] then			
data[tostring(target)]["settings"]["lock_mention"] = "no"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_edit"] then			
data[tostring(target)]["settings"]["lock_edit"] = "no"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_spam"] then			
data[tostring(target)]["settings"]["lock_spam"] = "yes"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_flood"] then			
data[tostring(target)]["settings"]["lock_flood"] = "yes"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_bots"] then			
data[tostring(target)]["settings"]["lock_bots"] = "yes"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_markdown"] then			
data[tostring(target)]["settings"]["lock_markdown"] = "no"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_webpage"] then			
data[tostring(target)]["settings"]["lock_webpage"] = "no"		
end
end

if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_all"] then			
data[tostring(target)]["mutes"]["mute_all"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_gif"] then			
data[tostring(target)]["mutes"]["mute_gif"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_text"] then			
data[tostring(target)]["mutes"]["mute_text"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_photo"] then			
data[tostring(target)]["mutes"]["mute_photo"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_video"] then			
data[tostring(target)]["mutes"]["mute_video"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_audio"] then			
data[tostring(target)]["mutes"]["mute_audio"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_voice"] then			
data[tostring(target)]["mutes"]["mute_voice"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_sticker"] then			
data[tostring(target)]["mutes"]["mute_sticker"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_contact"] then			
data[tostring(target)]["mutes"]["mute_contact"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_forward"] then			
data[tostring(target)]["mutes"]["mute_forward"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_location"] then			
data[tostring(target)]["mutes"]["mute_location"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_document"] then			
data[tostring(target)]["mutes"]["mute_document"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_tgservice"] then			
data[tostring(target)]["mutes"]["mute_tgservice"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_inline"] then			
data[tostring(target)]["mutes"]["mute_inline"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_game"] then			
data[tostring(target)]["mutes"]["mute_game"] = "no"		
end
end
local mutes = data[tostring(target)]["mutes"] 
local settings = data[tostring(target)]["settings"] 
local muter = redis:get('mute_time:'..msg.chat_id_)
  if muter then
  	mute_timer = 'yes'
  else
  	mute_timer = 'no'
  end
local text = "⚙*Group Settings:*\n🔹*Lock Edit :* "..settings.lock_edit.."\n🔹*Lock Links :* "..settings.lock_link.."\n🔹*Lock Hash :* "..settings.lock_hash.."\n🔹*Lock PmHash :* "..settings.lock_pmhash.."\n🔹*Lock Tags :* "..settings.lock_tag.."\n🔹*Lock Flood :* "..settings.flood.."\n🔹*Lock Spam :* "..settings.lock_spam.."\n🔹*Lock Mention :* "..settings.lock_mention.."\n🔹*Lock Webpage :* "..settings.lock_webpage.."\n🔹*Lock Markdown :* "..settings.lock_markdown.."\n🔹*Bots Remove :* "..settings.lock_bots.."\n🔹*Flood Sensitivity :* `"..NUM_MSG_MAX.."` \n➡️➡️➡️\n⚙*Group Mute List* : \n🔹*Mute All :* "..mutes.mute_all.."\n🔹*Mute Gif :* "..mutes.mute_gif.."\n🔹*Mute Text :* "..mutes.mute_text.."\n🔹*Mute Inline :* "..mutes.mute_inline.."\n🔹*Mute Game :* "..mutes.mute_game.."\n🔹*Mute Photo :* "..mutes.mute_photo.."\n🔹*Mute Video :* "..mutes.mute_video.."\n🔹*Mute Audio :* "..mutes.mute_audio.."\n🔹*Mute Voice :* "..mutes.mute_voice.."\n🔹*Mute Sticker :* "..mutes.mute_sticker.."\n🔹*Mute Contact :* "..mutes.mute_contact.."\n🔹*Mute Forward :* "..mutes.mute_forward.."\n🔹*Mute Location :* "..mutes.mute_location.."\n🔹*Mute Document :* "..mutes.mute_document.."\n🔹*Mute TgService :* "..mutes.mute_tgservice.."\n🔹*Mute Time :* "..mute_timer
  --text = text.."\n➡️          ⬅️\n⚙*Group Mute List* : \n🔹*Mute all :* "..mutes.mute_all.."\n🔹*Mute gif :* "..mutes.mute_gif.."\n🔹*Mute text :* "..mutes.mute_text.."\n🔹*Mute inline :* "..mutes.mute_inline.."\n🔹*Mute game :* "..mutes.mute_game.."\n🔹*Mute photo :* "..mutes.mute_photo.."\n🔹*Mute video :* "..mutes.mute_video.."\n🔹*Mute audio :* "..mutes.mute_audio.."\n🔹*Mute voice :* "..mutes.mute_voice.."\n🔹*Mute sticker :* "..mutes.mute_sticker.."\n🔹*Mute contact :* "..mutes.mute_contact.."\n🔹*Mute forward :* "..mutes.mute_forward.."\n🔹*Mute location :* "..mutes.mute_location.."\n🔹*Mute document :* "..mutes.mute_document.."\n🔹*Mute TgService :* "..mutes.mute_tgservice
  text = string.gsub(text, "yes", "✅")
  text = string.gsub(text, "no", "⛔️")
return text
end
--------Mutes---------
--------Mute all--------------------------
local function mute_all(msg, data, target) 
if not is_mod(msg) then
 return "*You're Not a* _Moderator_"
end

local mute_all = data[tostring(target)]["mutes"]["mute_all"] 
if mute_all == "yes" then
 return "*Mute all Is Already* `Enabled`"
else
 data[tostring(target)]["mutes"]["mute_all"] = "yes" 
save_data(_config.moderation.data, data) 
 return 
"*MuteAll Has Been* `Enabled`"
end
end

local function unmute_all(msg, data, target)
 if not is_mod(msg) then
return "*You're Not a* _Moderator_"
end 
local mute_all = data[tostring(target)]["mutes"]["mute_all"]
 if mute_all == "no" then
return "*Mute All Is Already* `Disabled`" 
else 
data[tostring(target)]["mutes"]["mute_all"] = "no"
 save_data(_config.moderation.data, data) 
return "*Mute All Has Been* `Disabled`" 
end
end
---------------Mute Gif-------------------
local function mute_gif(msg, data, target) 
if not is_mod(msg) then
 return "*You're Not a* _Moderator_"
end

local mute_gif = data[tostring(target)]["mutes"]["mute_gif"] 
if mute_gif == "yes" then
 return "*Mute Gif Is Already* `Enabled`"
else
 data[tostring(target)]["mutes"]["mute_gif"] = "yes" 
save_data(_config.moderation.data, data) 
 return "*Mute Gif Has Been* `Enabled`"
end
end

local function unmute_gif(msg, data, target)
 if not is_mod(msg) then
return "*You're Not a* _Moderator_"
end 
local mute_gif = data[tostring(target)]["mutes"]["mute_gif"]
 if mute_gif == "no" then
return "*Mute Gif Is Already* `Disabled`" 
else 
data[tostring(target)]["mutes"]["mute_gif"] = "no"
 save_data(_config.moderation.data, data) 
return "*Mute Gif Has Been* `Disabled`" 
end
end
---------------Mute Game-------------------
local function mute_game(msg, data, target) 
if not is_mod(msg) then
 return "*You're Not a* _Moderator_"
end

local mute_game = data[tostring(target)]["mutes"]["mute_game"] 
if mute_game == "yes" then
 return "*Mute Game Is Already* `Enabled`"
else
 data[tostring(target)]["mutes"]["mute_game"] = "yes" 
save_data(_config.moderation.data, data) 
 return "*Mute Game Has Been* `Enabled`"
end
end

local function unmute_game(msg, data, target)
 if not is_mod(msg) then
return "*You're Not a* _Moderator_"
end 
local mute_game = data[tostring(target)]["mutes"]["mute_game"]
 if mute_game == "no" then
return "*Mute Game Is Already* `Disabled`" 
else 
data[tostring(target)]["mutes"]["mute_game"] = "no"
 save_data(_config.moderation.data, data) 
return "*Mute Game Has Been* `Disabled`" 
end
end
---------------Mute Inline-------------------
local function mute_inline(msg, data, target) 
if not is_mod(msg) then
 return "*You're Not a* _Moderator_"
end

local mute_inline = data[tostring(target)]["mutes"]["mute_inline"] 
if mute_inline == "yes" then
 return "*Mute Inline Is Already* `Enabled`"
else
 data[tostring(target)]["mutes"]["mute_inline"] = "yes" 
save_data(_config.moderation.data, data) 
 return "*Mute Inline Has Been* `Enabled`"
end
end

local function unmute_inline(msg, data, target)
 if not is_mod(msg) then
return "*You're Not a* _Moderator_"
end 
local mute_inline = data[tostring(target)]["mutes"]["mute_inline"]
 if mute_inline == "no" then
return "*Mute Inline Is Already* `Disabled`" 
else 
data[tostring(target)]["mutes"]["mute_inline"] = "no"
 save_data(_config.moderation.data, data) 
return "*Mute Inline Has Been* `Disabled`" 
end
end
---------------Mute Text-------------------
local function mute_text(msg, data, target) 
if not is_mod(msg) then
 return "*You're Not a* _Moderator_"
end

local mute_text = data[tostring(target)]["mutes"]["mute_text"] 
if mute_text == "yes" then
 return "*Mute Text Is Already* `Enabled`"
else
 data[tostring(target)]["mutes"]["mute_text"] = "yes" 
save_data(_config.moderation.data, data) 
 return "*Mute Text Has Been* `Enabled`"
end
end

local function unmute_text(msg, data, target)
 if not is_mod(msg) then
return "*You're Not a* _Moderator_"
end 
local mute_text = data[tostring(target)]["mutes"]["mute_text"]
 if mute_text == "no" then
return "*Mute Text Is Already* `Disabled`" 
else 
data[tostring(target)]["mutes"]["mute_text"] = "no"
 save_data(_config.moderation.data, data) 
return "*Mute Text Has Been* `Disabled`" 
end
end
---------------Mute photo-------------------
local function mute_photo(msg, data, target) 
if not is_mod(msg) then
 return "*You're Not a* _Moderator_"
end

local mute_photo = data[tostring(target)]["mutes"]["mute_photo"] 
if mute_photo == "yes" then
 return "*Mute Photo Is Already* `Enabled`"
else
 data[tostring(target)]["mutes"]["mute_photo"] = "yes" 
save_data(_config.moderation.data, data) 
 return "*Mute Photo Has Been* `Enabled`"
end
end

local function unmute_photo(msg, data, target)
 if not is_mod(msg) then
return "*You're Not a* _Moderator_"
end 
local mute_photo = data[tostring(target)]["mutes"]["mute_photo"]
 if mute_photo == "no" then
return "*Mute Photo Is Already* `Disabled`" 
else 
data[tostring(target)]["mutes"]["mute_photo"] = "no"
 save_data(_config.moderation.data, data) 
return "*Mute Photo Has Been* `Disabled`" 
end
end
---------------Mute Video-------------------
local function mute_video(msg, data, target) 
if not is_mod(msg) then
 return "*You're Not a* _Moderator_"
end

local mute_video = data[tostring(target)]["mutes"]["mute_video"] 
if mute_video == "yes" then
 return "*Mute Video Is Already* `Enabled`"
else
 data[tostring(target)]["mutes"]["mute_video"] = "yes" 
save_data(_config.moderation.data, data) 
 return "*Mute Video Has Been* `Enabled`"
end
end

local function unmute_video(msg, data, target)
 if not is_mod(msg) then
return "*You're Not a* _Moderator_"
end 
local mute_video = data[tostring(target)]["mutes"]["mute_video"]
 if mute_video == "no" then
return "*Mute Video Is Already* `Disabled`" 
else 
data[tostring(target)]["mutes"]["mute_video"] = "no"
 save_data(_config.moderation.data, data) 
return "*Mute Video Has Been* `Disabled`" 
end
end
---------------Mute Audio-------------------
local function mute_audio(msg, data, target) 
if not is_mod(msg) then
 return "*You're Not a* _Moderator_"
end

local mute_audio = data[tostring(target)]["mutes"]["mute_audio"] 
if mute_audio == "yes" then
 return "*Mute Audio Is Already* `Enabled`"
else
 data[tostring(target)]["mutes"]["mute_audio"] = "yes" 
save_data(_config.moderation.data, data) 
 return "*Mute Audio Has Been* `Enabled`"
end
end

local function unmute_video(msg, data, target)
 if not is_mod(msg) then
return "*You're Not a* _Moderator_"
end 
local mute_audio = data[tostring(target)]["mutes"]["mute_audio"]
 if mute_audio == "no" then
return "*Mute Audio Is Already* `Disabled`" 
else 
data[tostring(target)]["mutes"]["mute_audio"] = "no"
 save_data(_config.moderation.data, data) 
return "*Mute Audio Has Been* `Disabled`" 
end
end
---------------Mute Voice-------------------
local function mute_voice(msg, data, target) 
if not is_mod(msg) then
 return "*You're Not a* _Moderator_"
end

local mute_voice = data[tostring(target)]["mutes"]["mute_voice"] 
if mute_voice == "yes" then
 return "*Mute Voice Is Already* `Enabled`"
else
 data[tostring(target)]["mutes"]["mute_voice"] = "yes" 
save_data(_config.moderation.data, data) 
 return "*Mute Voice Has Been* `Enabled`"
end
end

local function unmute_video(msg, data, target)
 if not is_mod(msg) then
return "*You're Not a* _Moderator_"
end 
local mute_voice = data[tostring(target)]["mutes"]["mute_voice"]
 if mute_voice == "no" then
return "*Mute Voice Is Already* `Disabled`" 
else 
data[tostring(target)]["mutes"]["mute_voice"] = "no"
 save_data(_config.moderation.data, data) 
return "*Mute Voice Has Been* `Disabled`" 
end
end
---------------Mute Sticker-------------------
local function mute_sticker(msg, data, target) 
if not is_mod(msg) then
 return "*You're Not a* _Moderator_"
end

local mute_sticker = data[tostring(target)]["mutes"]["mute_sticker"] 
if mute_sticker == "yes" then
 return "*Mute Sticker Is Already* `Enabled`"
else
 data[tostring(target)]["mutes"]["mute_sticker"] = "yes" 
save_data(_config.moderation.data, data) 
 return "*Mute Sticker Has Been* `Enabled`"
end
end

local function unmute_sticker(msg, data, target)
 if not is_mod(msg) then
return "*You're Not a* _Moderator_"
end 
local mute_sticker = data[tostring(target)]["mutes"]["mute_sticker"]
 if mute_sticker == "no" then
return "*Mute Sticker Is Already* `Disabled`" 
else 
data[tostring(target)]["mutes"]["mute_sticker"] = "no"
 save_data(_config.moderation.data, data) 
return "*Mute Sticker Has Been* `Disabled`" 
end
end
---------------Mute Contact-------------------
local function mute_contact(msg, data, target) 
if not is_mod(msg) then
 return "*You're Not a* _Moderator_"
end

local mute_contact = data[tostring(target)]["mutes"]["mute_contact"] 
if mute_contact == "yes" then
 return "*Mute Contact Is Already* `Enabled`"
else
 data[tostring(target)]["mutes"]["mute_contact"] = "yes" 
save_data(_config.moderation.data, data) 
 return "*Mute Contact Has Been* `Enabled`"
end
end

local function unmute_contact(msg, data, target)
 if not is_mod(msg) then
return "*You're Not a* _Moderator_"
end 
local mute_contact = data[tostring(target)]["mutes"]["mute_contact"]
 if mute_contact == "no" then
return "*Mute Contact Is Already* `Disabled`" 
else 
data[tostring(target)]["mutes"]["mute_contact"] = "no"
 save_data(_config.moderation.data, data) 
return "*Mute Contact Has Been* `Disabled`" 
end
end
---------------Mute Forward-------------------
local function mute_forward(msg, data, target) 
if not is_mod(msg) then
 return "*You're Not a* _Moderator_"
end

local mute_forward = data[tostring(target)]["mutes"]["mute_forward"] 
if mute_forward == "yes" then
 return "*Mute Forward Is Already* `Enabled`"
else
 data[tostring(target)]["mutes"]["mute_forward"] = "yes" 
save_data(_config.moderation.data, data) 
 return "*Mute Forward Has Been Enabled_"
end
end

local function unmute_forward(msg, data, target)
 if not is_mod(msg) then
return "*You're Not a* _Moderator_"
end 
local mute_forward = data[tostring(target)]["mutes"]["mute_forward"]
 if mute_forward == "no" then
return "*Mute Forward Is Already* `Disabled`" 
else 
data[tostring(target)]["mutes"]["mute_forward"] = "no"
 save_data(_config.moderation.data, data) 
return "*Mute Forward Has Been* `Disabled`" 
end
end
---------------Mute Location-------------------
local function mute_location(msg, data, target) 
if not is_mod(msg) then
 return "*You're Not a* _Moderator_"
end

local mute_location = data[tostring(target)]["mutes"]["mute_location"] 
if mute_location == "yes" then
 return "*Mute Location Is Already* `Enabled`"
else
 data[tostring(target)]["mutes"]["mute_location"] = "yes" 
save_data(_config.moderation.data, data) 
 return "*Mute Location Has Been* `Enabled`"
end
end

local function unmute_location(msg, data, target)
 if not is_mod(msg) then
return "*You're Not a* _Moderator_"
end 
local mute_location = data[tostring(target)]["mutes"]["mute_location"]
 if mute_location == "no" then
return "*Mute Location Is Already* `Disabled`" 
else 
data[tostring(target)]["mutes"]["mute_location"] = "no"
 save_data(_config.moderation.data, data) 
return "*Mute Location Has Been* `Disabled`" 
end
end
---------------Mute Document-------------------
local function mute_document(msg, data, target) 
if not is_mod(msg) then
 return "*You're Not a* _Moderator_"
end

local mute_document = data[tostring(target)]["mutes"]["mute_document"] 
if mute_document == "yes" then
 return "*Mute Document Is Already* `Enabled`"
else
 data[tostring(target)]["mutes"]["mute_document"] = "yes" 
save_data(_config.moderation.data, data) 
 return "*Mute Document Has Been* `Enabled`"
end
end

local function unmute_document(msg, data, target)
 if not is_mod(msg) then
return "*You're Not a* _Moderator_"
end 
local mute_document = data[tostring(target)]["mutes"]["mute_document"]
 if mute_document == "no" then
return "*Mute Document Is Already* `Disabled`" 
else 
data[tostring(target)]["mutes"]["mute_document"] = "no"
 save_data(_config.moderation.data, data) 
return "*Mute Document Has Been* `Disabled`" 
end
end
---------------Mute TgService-------------------
local function mute_tgservice(msg, data, target) 
if not is_mod(msg) then
 return "*You're Not a* _Moderator_"
end

local mute_tgservice = data[tostring(target)]["mutes"]["mute_tgservice"] 
if mute_tgservice == "yes" then
 return "*Mute TgService Is Already* `Enabled`"
else
 data[tostring(target)]["mutes"]["mute_tgservice"] = "yes" 
save_data(_config.moderation.data, data) 
 return "*Mute TgService Has Been* `Enabled`"
end
end

local function unmute_location(msg, data, target)
 if not is_mod(msg) then
return "*You're Not a* _Moderator_"
end 
local mute_tgservice = data[tostring(target)]["mutes"]["mute_tgservice"]
 if mute_tgservice == "no" then
return "*Mute TgService Is Already* `Disabled`" 
else 
data[tostring(target)]["mutes"]["mute_tgservice"] = "no"
 save_data(_config.moderation.data, data) 
return "*Mute TgService Has Been* `Disabled`" 
end
end
----------MuteList---------
--[[local function mutes(msg, target) 	
if not is_mod(msg) then
 	return "You're Not Moderator"	
end
local data = load_data(_config.moderation.data)
local target = msg.chat_id_ 
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_all"] then			
data[tostring(target)]["mutes"]["mute_all"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_gif"] then			
data[tostring(target)]["mutes"]["mute_gif"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_text"] then			
data[tostring(target)]["mutes"]["mute_text"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_photo"] then			
data[tostring(target)]["mutes"]["mute_photo"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_video"] then			
data[tostring(target)]["mutes"]["mute_video"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_audio"] then			
data[tostring(target)]["mutes"]["mute_audio"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_voice"] then			
data[tostring(target)]["mutes"]["mute_voice"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_sticker"] then			
data[tostring(target)]["mutes"]["mute_sticker"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_contact"] then			
data[tostring(target)]["mutes"]["mute_contact"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_forward"] then			
data[tostring(target)]["mutes"]["mute_forward"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_location"] then			
data[tostring(target)]["mutes"]["mute_location"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_document"] then			
data[tostring(target)]["mutes"]["mute_document"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_tgservice"] then			
data[tostring(target)]["mutes"]["mute_tgservice"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_inline"] then			
data[tostring(target)]["mutes"]["mute_inline"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_game"] then			
data[tostring(target)]["mutes"]["mute_game"] = "no"		
end
end
local mutes = data[tostring(target)]["mutes"] 
local text = " *Group Mute List* : \n_Mute all : _ *"..mutes.mute_all.."*\n_Mute gif :_ *"..mutes.mute_gif.."*\n_Mute text :_ *"..mutes.mute_text.."*\n_Mute inline :_ *"..mutes.mute_inline.."*\n_Mute game :_ *"..mutes.mute_game.."*\n_Mute photo :_ *"..mutes.mute_photo.."*\n_Mute video :_ *"..mutes.mute_video.."*\n_Mute audio :_ *"..mutes.mute_audio.."*\n_Mute voice :_ *"..mutes.mute_voice.."*\n_Mute sticker :_ *"..mutes.mute_sticker.."*\n_Mute contact :_ *"..mutes.mute_contact.."*\n_Mute forward :_ *"..mutes.mute_forward.."*\n_Mute location :_ *"..mutes.mute_location.."*\n_Mute document :_ *"..mutes.mute_document.."*\n_Mute TgService :_ *"..mutes.mute_tgservice.."*"
return text
end]]
local function run(msg, matches)
    local data = load_data(_config.moderation.data)
   local chat = msg.chat_id_
   local user = msg.sender_user_id_
if matches[1] == "id" then
if not matches[2] and tonumber(msg.reply_to_message_id_) == 0 then
return "🔹_Information:_\n✨*Group ID :* `"..chat.."`\n✨*User ID :* `"..user.."`"
end
if not matches[2] and tonumber(msg.reply_to_message_id_) ~= 0 then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.chat_id_,
      message_id_ = msg.reply_to_message_id_
    }, action_by_reply, {chat_id=msg.chat_id_,cmd="id"})
  end
if matches[2] and tonumber(msg.reply_to_message_id_) == 0 then
   tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.chat_id_,username=matches[2],cmd="id"})
      end
   end
if matches[1] == "pin" and is_owner(msg) then
tdcli.pinChannelMessage(msg.chat_id_, msg.reply_to_message_id_, 1)
return "*Message Has Been* `Pineed`"
end
if matches[1] == 'unpin' and is_mod(msg) then
tdcli.unpinChannelMessage(msg.chat_id_)
return "*Pin message has been* `unPinned`"
end
if matches[1] == "add" then
return modadd(msg)
end
if matches[1] == "rem" then
return modrem(msg)
end
if matches[1] == "setowner" and is_admin(msg) then
if not matches[2] and tonumber(msg.reply_to_message_id_) ~= 0 then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.chat_id_,
      message_id_ = msg.reply_to_message_id_
    }, action_by_reply, {chat_id=msg.chat_id_,cmd="setowner"})
  end
  if matches[2] and string.match(matches[2], '^%d+$') then
tdcli_function ({
    ID = "GetUser",
    user_id_ = matches[2],
  }, action_by_id, {chat_id=msg.chat_id_,user_id=matches[2],cmd="setowner"})
    end
  if matches[2] and not string.match(matches[2], '^%d+$') then
   tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.chat_id_,username=matches[2],cmd="setowner"})
      end
   end
if matches[1] == "remowner" and is_admin(msg) then
if not matches[2] and tonumber(msg.reply_to_message_id_) ~= 0 then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.chat_id_,
      message_id_ = msg.reply_to_message_id_
    }, action_by_reply, {chat_id=msg.chat_id_,cmd="remowner"})
  end
  if matches[2] and string.match(matches[2], '^%d+$') then
tdcli_function ({
    ID = "GetUser",
    user_id_ = matches[2],
  }, action_by_id, {chat_id=msg.chat_id_,user_id=matches[2],cmd="remowner"})
    end
  if matches[2] and not string.match(matches[2], '^%d+$') then
   tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.chat_id_,username=matches[2],cmd="remowner"})
      end
   end
if matches[1] == "promote" and is_owner(msg) then
if not matches[2] and tonumber(msg.reply_to_message_id_) ~= 0 then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.chat_id_,
      message_id_ = msg.reply_to_message_id_
    }, action_by_reply, {chat_id=msg.chat_id_,cmd="promote"})
  end
  if matches[2] and string.match(matches[2], '^%d+$') then
tdcli_function ({
    ID = "GetUser",
    user_id_ = matches[2],
  }, action_by_id, {chat_id=msg.chat_id_,user_id=matches[2],cmd="promote"})
    end
  if matches[2] and not string.match(matches[2], '^%d+$') then
   tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.chat_id_,username=matches[2],cmd="promote"})
      end
   end
if matches[1] == "demote" and is_owner(msg) then
if not matches[2] and tonumber(msg.reply_to_message_id_) ~= 0 then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.chat_id_,
      message_id_ = msg.reply_to_message_id_
    }, action_by_reply, {chat_id=msg.chat_id_,cmd="demote"})
  end
  if matches[2] and string.match(matches[2], '^%d+$') then
tdcli_function ({
    ID = "GetUser",
    user_id_ = matches[2],
  }, action_by_id, {chat_id=msg.chat_id_,user_id=matches[2],cmd="demote"})
    end
  if matches[2] and not string.match(matches[2], '^%d+$') then
    tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.chat_id_,username=matches[2],cmd="demote"})
      end
   end

if matches[1] == "lock" and is_mod(msg) then
local target = msg.chat_id_
if matches[2] == "link" then
return lock_link(msg, data, target)
end
if matches[2] == "tag" then
return lock_tag(msg, data, target)
end
if matches[2] == "mention" then
return lock_mention(msg, data, target)
end
if matches[2] == "edit" then
return lock_edit(msg, data, target)
end
if matches[2] == "spam" then
return lock_spam(msg, data, target)
end
if matches[2] == "flood" then
return lock_flood(msg, data, target)
end
if matches[2] == "bots" then
return lock_bots(msg, data, target)
end
if matches[2] == "markdown" then
return lock_markdown(msg, data, target)
end
if matches[2] == "webpage" then
return lock_webpage(msg, data, target)
end
if matches[2] == "hash" then
return lock_hash(msg, data, target)
end
if matches[2] == "pmhash" then
return lock_pmhash(msg, data, target)
end
end

if matches[1] == "unlock" and is_mod(msg) then
local target = msg.chat_id_
if matches[2] == "all" then
local unlock_all_command ={
        unlock_link(msg, data, target),
		unlock_tag(msg, data, target),
		unlock_mention(msg, data, target),
		unlock_edit(msg, data, target),
		unlock_spam(msg, data, target),
		unlock_flood(msg, data, target),
		unlock_bots(msg, data, target),
		unlock_markdown(msg, data, target),
		unlock_webpage(msg, data, target),
		unlock_hash(msg, data, target),
		unlock_pmhash(msg, data, target)

      	}
      	return '*All Lock Has Been* `Unlocked`', unlock_all_command
end
if matches[2] == "link" then
return unlock_link(msg, data, target)
end
if matches[2] == "tag" then
return unlock_tag(msg, data, target)
end
if matches[2] == "mention" then
return unlock_mention(msg, data, target)
end
if matches[2] == "edit" then
return unlock_edit(msg, data, target)
end
if matches[2] == "spam" then
return unlock_spam(msg, data, target)
end
if matches[2] == "flood" then
return unlock_flood(msg, data, target)
end
if matches[2] == "bots" then
return unlock_bots(msg, data, target)
end
if matches[2] == "markdown" then
return unlock_markdown(msg, data, target)
end
if matches[2] == "webpage" then
return unlock_webpage(msg, data, target)
end
if matches[2] == "hash" then
return unlock_hash(msg, data, target)
end
if matches[2] == "pmhash" then
return unlock_pmhash(msg, data, target)
end
end
if matches[1] == "mute" and is_mod(msg) then
local target = msg.chat_id_
if matches[2] == "all" then
return mute_all(msg, data, target)
end
if matches[2] == "gif" then
return mute_gif(msg ,data, target)
end
if matches[2] == "text" then
return mute_text(msg ,data, target)
end
if matches[2] == "photo" then
return mute_photo(msg ,data, target)
end
if matches[2] == "video" then
return mute_video(msg ,data, target)
end
if matches[2] == "audio" then
return mute_audio(msg ,data, target)
end
if matches[2] == "voice" then
return mute_voice(msg ,data, target)
end
if matches[2] == "sticker" then
return mute_sticker(msg ,data, target)
end
if matches[2] == "contact" then
return mute_contact(msg ,data, target)
end
if matches[2] == "forward" then
return mute_forward(msg ,data, target)
end
if matches[2] == "location" then
return mute_location(msg ,data, target)
end
if matches[2] == "document" then
return mute_document(msg ,data, target)
end
if matches[2] == "tgservice" then
return mute_tgservice(msg ,data, target)
end
if matches[2] == "inline" then
return mute_inline(msg ,data, target)
end
if matches[2] == "game" then
return mute_game(msg ,data, target)
end
end

if matches[1] == "unmute" and is_mod(msg) then
local target = msg.chat_id_
if matches[2] == "all" then
return unmute_all(msg, data, target)
end
if matches[2] == "gif" then
return unmute_gif(msg, data, target)
end
if matches[2] == "text" then
return unmute_text(msg, data, target)
end
if matches[2] == "photo" then
return unmute_photo(msg ,data, target)
end
if matches[2] == "video" then
return unmute_video(msg ,data, target)
end
if matches[2] == "audio" then
return unmute_audio(msg ,data, target)
end
if matches[2] == "voice" then
return unmute_voice(msg ,data, target)
end
if matches[2] == "sticker" then
return unmute_sticker(msg ,data, target)
end
if matches[2] == "contact" then
return unmute_contact(msg ,data, target)
end
if matches[2] == "forward" then
return unmute_forward(msg ,data, target)
end
if matches[2] == "location" then
return unmute_location(msg ,data, target)
end
if matches[2] == "document" then
return unmute_document(msg ,data, target)
end
if matches[2] == "tgservice" then
return unmute_tgservice(msg ,data, target)
end
if matches[2] == "inline" then
return unmute_inline(msg ,data, target)
end
if matches[2] == "game" then
return unmute_game(msg ,data, target)
end
end
if matches[1] == "gpinfo" and gp_type(msg.chat_id_) == "channel" then
local function group_info(arg, data)
local text = "🔹*Group Information:*\n✨_Admin Count:_  `"..data.administrator_count_.."`\n✨_Member Count:_  `"..data.member_count_.."`\n✨_Kicked Count:_  `"..data.kicked_count_.."`\n✨_Group ID:_  `"..data.channel_.id_.."`"
print(serpent.block(data))
        tdcli.sendMessage(arg.chat_id, arg.msg_id, 1, text, 1, 'md')
end
 tdcli.getChannelFull(msg.chat_id_, group_info, {chat_id=msg.chat_id_,msg_id=msg.id_})
end
		if matches[1] == 'setlink' and is_owner(msg) then
			data[tostring(chat)]['settings']['linkgp'] = 'waiting'
			save_data(_config.moderation.data, data)
			return '_Please send to me the new group_ `Link` _now_'
		end

		if msg.content_.text_ then
   local is_link = msg.content_.text_:match("^([https?://w]*.?telegram.me/joinchat/%S+)$") or msg.content_.text_:match("^([https?://w]*.?t.me/joinchat/%S+)$")
			if is_link and data[tostring(chat)]['settings']['linkgp'] == 'waiting' and is_owner(msg) then
				data[tostring(chat)]['settings']['linkgp'] = msg.content_.text_
				save_data(_config.moderation.data, data)
				return "`NewLink` _has been set_"
			end
		end
    if matches[1] == 'link' and is_mod(msg) then
      local linkgp = data[tostring(chat)]['settings']['linkgp']
      if not linkgp then
        return "_First set a link for group with using 》/setlink《_"
      end
      local text = "<b>Group Link :</b>\n"..linkgp
        return tdcli.sendMessage(chat, msg.id_, 1, text, 1, 'html')
		end
  if matches[1] == "setrules" and matches[2] and is_mod(msg) then
    data[tostring(chat)]['rules'] = matches[2]
	  save_data(_config.moderation.data, data)
    return "`Group Rules` _has been set!_"
  end
  if matches[1] == "rules" then
 if not data[tostring(chat)]['rules'] then
     rules = "ℹ️ The Default Rules :\n1⃣ No Flood.\n2⃣ No Spam.\n3⃣ No Advertising.\n4⃣ Try to stay on topic.\n5⃣ Forbidden any racist, sexual, homophobic or gore content.\n➡️ Repeated failure to comply with these rules will cause ban.\n@To0fan"
        else
     rules = "*Group Rules:*\n"..data[tostring(chat)]['rules']
      end
    return rules
  end
if matches[1] == "res" and matches[2] and is_mod(msg) then
    tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.chat_id_,username=matches[2],cmd="res"})
  end
if matches[1] == "uid" and matches[2] and is_mod(msg) then
tdcli_function ({
    ID = "GetUser",
    user_id_ = matches[2],
  }, action_by_id, {chat_id=msg.chat_id_,user_id=matches[2],cmd="uid"})
  end
  if matches[1] == 'setflood' and is_mod(msg) then
			if tonumber(matches[2]) < 1 or tonumber(matches[2]) > 50 then
				return "_Wrong number, range is_ `[1-50]`"
        end
			local flood_max = matches[2]
			data[tostring(chat)]['settings']['num_msg_max'] = flood_max
			save_data(_config.moderation.data, data)
    return "_Group_ `flood` _sensitivity has been set to :_ `[ "..matches[2].." ]`"
       end
		if matches[1]:lower() == 'clean' and is_owner(msg) then
			if matches[2] == 'mods' then
				if next(data[tostring(chat)]['mods']) == nil then
					return "*No* _Moderators_ *in this Group*"
				end
				for k,v in pairs(data[tostring(chat)]['mods']) do
					data[tostring(chat)]['mods'][tostring(k)] = nil
					save_data(_config.moderation.data, data)
				end
				return "*All* _Moderators_ *has been Demoted*"
			end
			if matches[2] == 'rules' then
				if not data[tostring(chat)]['rules'] then
					return "*No* _Rules_ *available*"
				end
					data[tostring(chat)]['rules'] = nil
					save_data(_config.moderation.data, data)
				return "_Group Rules_ *has been cleaned*"
			end
			if matches[2] == 'about' then
        if gp_type(chat) == "chat" then
				if not data[tostring(chat)]['about'] then
					return "*No* _Description_ *available*"
				end
					data[tostring(chat)]['about'] = nil
					save_data(_config.moderation.data, data)
        elseif gp_type(chat) == "channel" then
					tdcli.changeChannelAbout(chat, "", dl_cb, nil)
             end
				return "_Group Description_ *has been cleaned*"
		   	end
        end
		if matches[1]:lower() == 'clean' and is_admin(msg) then
			if matches[2] == 'owners' then
				if next(data[tostring(chat)]['owners']) == nil then
					return "*No* _Owners_ *in this Group*"
				end
				for k,v in pairs(data[tostring(chat)]['owners']) do
					data[tostring(chat)]['owners'][tostring(k)] = nil
					save_data(_config.moderation.data, data)
				end
				return "*All* _Owners_ *has been demoted*"
			end
     end
if matches[1] == "setname" and matches[2] and is_mod(msg) then
local gp_name = string.gsub(matches[2], "_","")
tdcli.changeChatTitle(chat, gp_name, dl_cb, nil)
end
  if matches[1] == "setabout" and matches[2] and is_mod(msg) then
     if gp_type(chat) == "channel" then
   tdcli.changeChannelAbout(chat, matches[2], dl_cb, nil)
    elseif gp_type(chat) == "chat" then
    data[tostring(chat)]['about'] = matches[2]
	  save_data(_config.moderation.data, data)
     end
    return "_Group Description_ *has been set*" 
  end
  if matches[1] == "about" and gp_type(chat) == "chat" then
 if not data[tostring(chat)]['about'] then
     about = "*No* _Description_ *available*"
        else
     about = "*Group Description:*\n"..data[tostring(chat)]['about']
      end
    return about
  end
if matches[1] == "settings" then
return group_settings(msg, target)
end
--[[if matches[1] == "mutelist" then
return mutes(msg, target)
end]]
if matches[1] == "modlist" then
return modlist(msg)
end
if matches[1] == "ownerlist" and is_owner(msg) then
return ownerlist(msg)
end

if matches[1] == "help" and is_mod(msg) then
text = [[
*Bot Commands:*

*!setowner* `[username|id|reply]` 
_Set Group Owner(Multi Owner)_

*!remowner* `[username|id|reply]` 
 _Remove User From Owner List_

*!promote* `[username|id|reply]` 
_Promote User To Group Admin_

*!demote* `[username|id|reply]` 
_Demote User From Group Admins List_

*!setflood* `[1-50]`
_Set Flooding Number_

*!silent* `[username|id|reply]` 
_Silent User From Group_

*!unsilent* `[username|id|reply]` 
_Unsilent User From Group_

*!kick* `[username|id|reply]` 
_Kick User From Group_

*!ban* `[username|id|reply]` 
_Ban User From Group_

*!unban* `[username|id|reply]` 
_UnBan User From Group_

*!res* `[username]`
_Show User ID_

*!id* `[reply]`
_Show User ID_

*!uid* `[id]`
_Show User's Username And Name_

*!lock* `[link | tag | hash | pmhash | edit | webpage | bots | spam | flood | markdown | mention]`
_If This Actions Lock, Bot Check Actions And Delete Them_

*!unlock* `[all | link | tag | hash | pmhash | edit | webpage | bots | spam | flood | markdown | mention]`
_If This Actions Unlock, Bot Not Delete Them_

*!mute* `[gifs | photo | doc | sticker | video | text | fwd | loc | audio | voice | contact | all]`
_If This Actions Lock, Bot Check Actions And Delete Them_

*!unmute* `[gifs | photo | doc | sticker | video | text | fwd | loc | audio | voice | contact | all]`
_If This Actions Unlock, Bot Not Delete Them_

*!set*`[rules | name | photo | link | about]`
_Bot Set Them_

*!clean* `[bans | mods | bots | rules | about | silentlist]`   
_Bot Clean Them_

*!pin* `[reply]`
_Pin Your Message_

*!unpin* 
_Unpin Pinned Message_

*!settings*
_Show Group Settings_

*!silentlist*
_Show Silented Users List_

*!banlist*
_Show Banned Users List_

*!ownerlist*
_Show Group Owners List_ 

*!modlist* 
_Show Group Moderators List_

*!rules*
_Show Group Rules_

*!about*
_Show Group Description_

*!id*
_Show Your And Chat ID_

*!gpinfo*
_Show Group Information_

*!link*
_Show Group Link_

_You Can Use_ *[!/#]* _To Excute The Commands_
_This Help List Only Can Be Used By_ *Moderators/Owners!*

*Cheers.*]]
return text
end
end
return {
patterns ={
"^[!/#](id)$",
"^[!/#](id) (.*)$",
"^[!/#](pin)$",
"^[!/#](unpin)$",
"^[!/#](gpinfo)$",
"^[!/#](add)$",
"^[!/#](rem)$",
"^[!/#](setowner)$",
"^[!/#](setowner) (.*)$",
"^[!/#](remowner)$",
"^[!/#](remowner) (.*)$",
"^[!/#](promote)$",
"^[!/#](promote) (.*)$",
"^[!/#](demote)$",
"^[!/#](demote) (.*)$",
"^[!/#](modlist)$",
"^[!/#](ownerlist)$",
"^[!/#](lock) (.*)$",
"^[!/#](unlock) (.*)$",
"^[!/#](settings)$",
--"^[!/#](mutelist)$",
"^[!/#](mute) (.*)$",
"^[!/#](unmute) (.*)$",
"^[!/#](link)$",
"^[!/#](setlink)$",
"^[!/#](rules)$",
"^[!/#](setrules) (.*)$",
"^[!/#](about)$",
"^[!/#](setabout) (.*)$",
"^[!/#](setname) (.*)$",
"^[!/#](clean) (.*)$",
"^[!/#](setflood) (%d+)$",
"^[!/#](res) (.*)$",
"^[!/#](uid) (%d+)$",
"^[!/#](help)$",
"^([https?://w]*.?t.me/joinchat/%S+)$",
"^([https?://w]*.?telegram.me/joinchat/%S+)$",
},
run=run
}
