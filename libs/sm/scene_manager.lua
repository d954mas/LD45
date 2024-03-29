local COMMON = require "libs.common"
local Stack = require "libs.sm.stack"
local TAG = "SM"

---@class SceneManager
local M = COMMON.class("SceneManager")

local unload_modals

function M:initialize()
    self.stack = Stack()
    ---@type Scene[]
    self.scenes = {}
    self.co = nil
end

---@param scenes Scene[]
function M:register(scenes)
    assert(#self.scenes == 0, "register_scenes can be called only once")
    assert(scenes, "scenes can't be nil")
    assert(#scenes ~= 0, "scenes should have one or more scene")
    for _, scene in ipairs(scenes) do
        assert(not scene.__declaredMethods, "register instance not class(add ())")
        assert(scene._name, "scene name can't be nil")
        assert(not self.scenes[scene._name], "scene:" .. scene._name .. " already exist")
        self.scenes[scene._name] = scene
        scene._sm = self
    end
end

---@param self SceneManager
---@param scene Scene
local function check(self,scene)
    assert(self.co, "no running co")
    assert(scene, "scene can't be nil")
end

---@param self SceneManager
---@param scene Scene
local function load(self,scene)
    check(self,scene)
    COMMON.i("start load scene:" .. scene._name, TAG)
    local start_loading_time = os.clock()
    scene:load():subscribe(nil,nil,function()
        COMMON.i("load scene:" .. scene._name .. " done", TAG)
        COMMON.i("load time:" .. os.clock() - start_loading_time, TAG)
    end)
end


---@param self SceneManager
---@param scene Scene
local function show(scene, input)
    scene._input = input
    scene:show()
end

---@param self SceneManager
---@param scene Scene
---@param transition string
local function scene_transition(self,scene,transition)
    check(self, scene)
    COMMON.i("transition " ..  transition .. ":" .. scene._name, TAG)
    scene._in_transition = true
    scene:transition(transition)
    while scene._in_transition do
        coroutine.yield()
    end
    COMMON.i("transition " ..  transition .. " end:" .. scene._name, TAG)--]]
end


---unload prev scene with all it modals. If next scene is modal then do not hide current
---@param self SceneManager
---@param scene Scene
---@param new_scene Scene|nil need for waiting next scene loading done before hide scene
local function unload_scene(self,scene,new_scene)
    assert(self, "self can't be nil")
    assert(scene, "scene can't be nil")
    local STATES = scene.STATIC.STATES
    COMMON.i("release input for scene:" .. scene._name, TAG)
    msg.post(scene._url,COMMON.HASHES.INPUT_RELEASE_FOCUS)
    if scene._state == STATES.RUNNING then
        scene_transition(self,scene,scene.STATIC.TRANSITIONS.ON_HIDE)
        scene:pause()
    end
    local modal = new_scene and new_scene._config.modal
    --wait next scene loaded
    while new_scene and new_scene._state == STATES.LOADING do coroutine.yield() end
    if scene._state == STATES.PAUSED and not modal then
        scene:hide()
    end
    if scene._state == STATES.HIDE then
        scene:unload()
    end
end


--COROUTUINES FUN
--show new scene, hide old scene
---@param old_scene Scene|nil
---@param new_scene Scene
local function show_new_scene(self, old_scene, new_scene, input,options)
    assert(self, "self can't be nil")
    assert(new_scene or options.to_init_collection, "new_scene can't be nil")
    options = options or {}
    if options.delay then
        COMMON.i("change scene delay:" .. options.delay)
        COMMON.coroutine_wait(options.delay)
    end
    local start_time = os.clock()
    local STATES
    COMMON.i("change scene from " .. (old_scene and old_scene._name or "nil") .. " to " .. (new_scene and new_scene._name or "nil"),TAG)

    if new_scene then
        STATES  = new_scene.STATIC.STATES
        if new_scene == old_scene and not options.reload then
            COMMON.i("scene:" .. new_scene._name .. " already on top")
            self.co = nil
            return
        end
        --try preload scene
        if new_scene._state == STATES.UNLOADED then
            load(self,new_scene)
        end
    end

    if not new_scene._config.modal then
        local co = self.co
        unload_modals(self)
        self.co = co
    end
    if old_scene then unload_scene(self,old_scene,new_scene) end

    if new_scene then
        --need for reload
        if new_scene._state == STATES.UNLOADED then
            load(self,new_scene)
        end

        --wait next scene loaded
        while new_scene._state == STATES.LOADING do coroutine.yield() end

        if new_scene._state == STATES.LOADED then
            new_scene:init()
        end

        if new_scene._state == STATES.HIDE then
            show(new_scene, input)
        end

        if new_scene._state == STATES.PAUSED then
            new_scene:resume()
            scene_transition(self,new_scene,new_scene.STATIC.TRANSITIONS.ON_SHOW)
        end
    end
    if new_scene then
        COMMON.i("acquire input for scene:" .. new_scene._name, TAG)
        msg.post(new_scene._url,COMMON.HASHES.INPUT_ACQUIRE_FOCUS)
    end
    self.co = nil
    COMMON.i(string.format("scene changed from:%s to:%s",old_scene and old_scene._name or tostring(nil)
    ,new_scene and new_scene._name or "nil"), TAG)
    COMMON.i("time:" .. (os.clock() - start_time),TAG)
end

---@param self SceneManager
unload_modals = function(self)
    COMMON.i("start unload modals",TAG)
    while(true)do
        local co = self.co
        local scene = self.stack:peek()
        if not scene or not scene._config.modal then break end
        scene = self.stack:pop()
        print("unload modal scene:" ..scene._name)
        show_new_scene(self, scene, self.stack:peek())
        self.co = co
    end
    self.co = nil
    COMMON.i("unload modal end",TAG)
end

local function reload_scene(self)
    local co = self.co
    unload_modals(self)
    self.co = co
    local scene_name, input  = self.stack:peek()._name, self.stack:peek()._input
    local options = {reload = true}
    local scene = assert(self:get_scene_by_name(scene_name))
    local current_scene =  scene._config.modal and self.stack:peek() or self.stack:pop()
    self.stack:push(scene)
    show_new_scene(self, current_scene, scene, input, options)
    self.co = nil
end

function M:show(scene_name, input, options)
    assert(not self.co, "work in progress.Can't show new scene")
    input = input or {}
    options = options or {}
    local scene = assert(self:get_scene_by_name(scene_name))
    self.co = coroutine.create(function()
        if options.close_modals then
            local co = self.co
            unload_modals(self)
            self.co = co
        end
        local current_scene =  scene._config.modal and self.stack:peek() or self.stack:pop()
        show_new_scene( self, current_scene, scene, input, options)
        self.stack:push(scene)
    end)
    local ok, res = coroutine.resume(self.co)
    if not ok then
        COMMON.e(res, TAG)
        self.co = nil
    end
end

function M:back(input, options)
    assert(not self.co, "work in progress.Can't show new scene")
    self.co = coroutine.create(function()
        if options and options.close_modals then
            local co = self.co
            unload_modals(self)
            self.co = co
        end
        local prev_scene =  self.stack:pop()
        show_new_scene(self, prev_scene, self.stack:peek(), input, options)
    end)

    local ok, res = coroutine.resume(self.co)
    if not ok then
        COMMON.e(res, TAG)
        self.co = nil
    end
end

--reload top. It can be modal
function M:reload()
   self:show(self.stack:peek()._name,self.stack:peek()._input, {reload = true})
end

function M:reload_scene()
    assert(not self.co, "work in progress.Can't show new scene")
    self.co = coroutine.create(reload_scene)
    COMMON.coroutine_resume(self.co,self)
end

function M:close_modals()
    assert(not self.co, "work in progress.Can't show new scene")
    self.co = coroutine.create(unload_modals)
    COMMON.coroutine_resume(self.co,self)
end

--region UTILS

---@return Scene
function M:get_scene_by_name(name)
    local scene = self.scenes[assert(name, "name can't be nil")]
    return assert(scene, "unknown scene:" .. name)
end
--endregion

--keep loading or transitions
--call it from main
function M:update(dt)
    if self.co then
        local ok, res = coroutine.resume(self.co,dt)
        if not ok then
            COMMON.e(res, TAG)
            self.co = nil
        end
    end
end

function M:is_loading()
    return self.co
end

function M:is_show_modal(name)
    local scene = self:get_scene_by_name(name)
    if not scene._config.modal then
        COMMON.w("scene:" .. name .. " is not modal",TAG)
        return false
    end
    for i=#self.stack,1,-1 do
        ---@type Scene
        local current_scene = self.stack[i]
        if current_scene == scene then return true end
        if not current_scene._config.modal then
            return false
        end
    end
end



return M