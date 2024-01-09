--译者: WocSavee(Savee14702)
--我语文在及格线徘徊所以1没文采2可能表达不出意思


local Lang = {}
Lang._LanguageName = "SChinese(简体中文)"

Lang.NSPW_TOOL_CATEGORY_PPM = "属性修改器"

Lang.NSPW_NAMEGENERATOR_MULT = "复杂"
Lang.NSPW_NAMEGENERATOR_HEAVY = "沉重"
Lang.NSPW_NAMEGENERATOR_END = "的 "

Lang.UserManual = [[
NSPW 用户手册
撰写者: Savee14702

	-> 什么是NSPW?
	NSPW(Not Simple Prop to Weapon(不简单的物件到武器),你也可以叫它NSP2W)
	SPW(现在已死,但尚有备份)的续作
	(复活次数: 3)
	该插件的目标旨在让玩家随手抄起一个Prop然后将其砸向你的敌人(SPW,NSPW共有)
	但如今,该插件(NSPW)经过升级后已经支持一些SPW没有的功能
	他们包括
	->> 支持Dupe
	->> 支持枪械
	->> 一些有特殊作用的物品(装在枪上可提高子弹伤害等)
	->> 多种HoldType(握持方式)
	->> 自定义Prop
	->> 支持Wiremod E2
	->> 以及方便的UI

	-> 使用方法
		->> 基础
			一切都需要有一个键位来执行
			所以按下F10,或者~(Esc下面)呼出控制台,
			然后输入bind"键位""savee_nspw_debug_pickup
			将[键位]替换为你想要的键位(比如bind"n""savee_nspw_debug_pickup)
			如果你不想它占用你的键位,你也可以瞄向一个物品,然后呼出控制台并输入savee_nspw_debug_pickup
			如果一切正常且合理(参照下面的捡起条件&控制台介绍),你会捡起对应的Prop

		->> 操作
			-> 鼠标左键/主要攻击键: [近战]挥舞||[枪械]开火/拉栓(上膛)
			-> 鼠标右键/次要攻击键: [近战]格挡||[枪械]瞄准/次要攻击
			-> 换弹键: [枪械]上子弹
			-> 使用键+换弹键: 唤出握持样式菜单
			-> 使用键+鼠标右键: 扔下武器

		->> 近战
			-> 攻击
				在进攻时,你应该确保你的敌人在你的屏幕偏右侧(大概右侧部分中间的位置),否则无法确保能精准命中敌人
				武器的伤害和冷却时间是根据物品总重量决定的
				部分武器有特殊的数据表(这也是枪械工作的方式)
				这意味着较长的武器有较长的攻击距离(也可以通过不同握持方式延长)
			-> 格挡
				通过[鼠标右键/次要攻击键],你可以进入格挡姿态
				在这期间你所受近战伤害会减少,但是代价是你的武器会受到一定的伤害
				注意-如果伤害过大,你的武器会被崩飞(SPW特性),所以不要尝试用小刀格挡蚁狮守卫的攻击!
		
		->> 枪械
			-> 射击
				通过不同的配件(也是Prop)你可以更改你的子弹(轨迹和命中效果)
				在枪械射击时会产生后坐力,如果你的武器过重,后坐力会变大
				后坐力分为视觉后座和真实后座(会抬升你的枪口)
				和枪械有关的握持方式没有显著的变化,但使用单手握持方式射击双手武器会有扩散和后座惩罚
				(单手武器的握持姿态上子弹比双手武器的握持姿态上子弹快)

			-> 瞄准
				这里没什么好说的,不同武器瞄准镜不同,在瞄准时你的鼠标灵敏度会下降
				
			->> 换弹/其它 
				你不能使用单手握持方式更换双手武器的弹夹(SMG1,TMP这类弹夹插在握把上的除外)
				当你使用栓动武器射击后,需要手动按下[鼠标左键/主要攻击键]拉栓
				使用泵动霰弹枪射击后,如果武器过重需要手动按下[鼠标左键/主要攻击键]上膛

		->> 捡起条件
			> 距离够近
			> 物品总质量够小
			> 约束只有无碰撞和焊接

		->> 控制台指令
			格式: 指令 默认值 介绍

			savee_nspw_debugprint 0 [开发者]打开没什么用的DebugPrint(因为我都删没了)
			savee_nspw_debug_slowtrace 0 [开发者]让你观赏射出的子弹轨迹

			savee_nspw_heavygun 20 当总质量超过此值时,武器将被标记为重武器(只对枪械有效)

			savee_nspw_masslimit 35 物品总质量超过此值你就不能捡起那个物品

	-> 贡献
		->> Savee14702 - 代码,模型(动画),主体思想
		->> 稻谷MCUT - 优化指导

	-> 宣传
		->> TheBillinator3000: 介绍SPW(或者SP2W)
		->> NecrosViedos: 介绍SPW(或者SP2W)(以及留了个能用的存档)

	-> 个人请求
		我建模能力差,不能搓人模
		如果你想帮忙的话,麻烦搓一个Miku(带狐耳和狐尾的那种...)的R18/NSFW(一个意思)模型然后发到工坊上...谢谢了
		-Savee14702

	
]]


return Lang
