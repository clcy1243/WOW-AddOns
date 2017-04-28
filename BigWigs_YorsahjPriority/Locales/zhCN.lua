local L = BigWigs:NewBossLocale("Yor'sahj Priority", "zhCN")
if not L then return end
if L then
	L.modname = "约萨希优先级"

	L.blobs = "血球"
	L.blobs_desc = "使用 /bwyp 命令打开更多选项"
	L.blobs_message = "击杀 >>%s<<"

	L.warn = "团队警报"
	L.warn_desc = "在团队警报通知团队需要击杀哪个血球。需要权限。"

	L.update = "血球优先级'%s'更新为%s由%s更新。"
	L.denied = "你必须是团队领袖或助理才可这么做！"
	L.allowed = "团队成员已被更新。"
	L.loaded = "已加载。/bwyp 进行配置。"
	L.button = "红色大按钮"
	L.button_header = "团队成员是在使用约萨希优先级吗？需要更新到最新的优先级吗？你是团队领袖或者助理吗？来吧，大红按钮就是为你准备的！"
end

