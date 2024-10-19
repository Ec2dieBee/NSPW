return util.JSONToTable([[{
	"DupeData": {
		"Mins": "[-3.7587 -2.1051 -1]",
		"Constraints": {
			"6461": {
				"Entity": [
					{
						"Bone": 0.0,
						"World": false,
						"Index": 112.0
					},
					{
						"Bone": 0.0,
						"World": false,
						"Index": 114.0
					}
				],
				"Bone1": 0.0,
				"Type": "Weld",
				"Bone2": 0.0,
				"BuildDupeInfo": {
					"Ent2Ang": "{-0.0067 -0.0048 45.0249}",
					"Ent1Pos": "[788.7922 -742.6504 456.6629]",
					"EntityPos": "[6.4759 -3.3589 3.3568]",
					"Ent1Ang": "{45 -90.0293 180}"
				}
			},
			"6460": {
				"Entity": [
					{
						"Bone": 0.0,
						"World": false,
						"Index": 111.0
					},
					{
						"Bone": 0.0,
						"World": false,
						"Index": 114.0
					}
				],
				"Bone1": 0.0,
				"Type": "Weld",
				"Bone2": 0.0,
				"BuildDupeInfo": {
					"Ent2Ang": "{0.0072 -89.974 0.0002}",
					"Ent1Pos": "[-1301.7085 -1188.7246 -364.8848]",
					"EntityPos": "[0.0448 -8.2832 3.7485]",
					"Ent1Ang": "{0 -89.9813 0}"
				}
			},
			"6462": {
				"Entity": [
					{
						"Bone": 0.0,
						"World": false,
						"Index": 110.0
					},
					{
						"Bone": 0.0,
						"World": false,
						"Index": 114.0
					}
				],
				"Bone1": 0.0,
				"Type": "Weld",
				"Bone2": 0.0,
				"BuildDupeInfo": {
					"Ent2Ang": "{0.0072 -89.974 0.0002}",
					"Ent1Pos": "[-1301.7389 -1190.0038 -366.6095]",
					"EntityPos": "[0.0144 -9.5624 2.0238]",
					"Ent1Ang": "{-89.9991 -89.9816 180}"
				}
			},
			"6459": {
				"Entity": [
					{
						"Bone": 0.0,
						"World": false,
						"Index": 83.0
					},
					{
						"Bone": 0.0,
						"World": false,
						"Index": 114.0
					}
				],
				"Bone1": 0.0,
				"Type": "Weld",
				"Bone2": 0.0,
				"BuildDupeInfo": {
					"Ent2Ang": "{-0.0067 -0.0048 45.0249}",
					"Ent1Pos": "[793.0685 -743.177 457.2502]",
					"EntityPos": "[10.7521 -3.8855 3.944]",
					"Ent1Ang": "{-45 -90.0265 90}"
				}
			},
			"6463": {
				"Entity": [
					{
						"Bone": 0.0,
						"World": false,
						"Index": 105.0
					},
					{
						"Bone": 0.0,
						"World": false,
						"Index": 114.0
					}
				],
				"Bone1": 0.0,
				"Type": "Weld",
				"Bone2": 0.0,
				"BuildDupeInfo": {
					"Ent2Ang": "{-0.0067 -0.0048 45.0249}",
					"Ent1Pos": "[792.2486 -743.5211 457.1112]",
					"EntityPos": "[9.9323 -4.2296 3.8051]",
					"Ent1Ang": "{0 -179.9731 90}"
				}
			}
		},
		"Maxs": "[11.8562 1.4212 7.1486]",
		"Entities": {
			"111": {
				"Base": "base_wire_entity",
				"PrintName": "Wire Lamp",
				"PhysicsObjects": {
					"0": {
						"Pos": "[8.2827 0.0411 3.7496]",
						"Frozen": true,
						"Angle": "{-0.0072 -0.0073 -0.0002}"
					}
				},
				"r": 255.0,
				"Contact": "",
				"Brightness": 8.0,
				"Health": 0.0,
				"Dist": 1024.0,
				"EntityMods": {
					"advr": [
						0.25,
						0.10000000149011612,
						0.10000000149011612,
						0.25,
						0.10000000149011612,
						0.10000000149011612,
						false
					],
					"WireDupeInfo": {
						"Wires": {
							"On": {
								"Path": [],
								"Material": "cable/cable2",
								"Width": 0.0,
								"SrcId": "FL",
								"Color": {
									"r": 255.0,
									"b": 255.0,
									"a": 255.0,
									"g": 255.0
								},
								"SrcPos": "[-0.0313 0.0313 -0.25]",
								"StartPos": "[1.9688 0.4063 -0.0938]",
								"Src": 113.0
							}
						}
					}
				},
				"LINK_STATUS_INACTIVE": 2.0,
				"AdminOnly": false,
				"DT": {
					"On": false
				},
				"Inputs": {
					"RGB": {
						"Name": "RGB",
						"Material": "tripmine_laser",
						"Width": 1.0,
						"Value": "[0 0 0]",
						"Color": {
							"r": 255.0,
							"b": 255.0,
							"a": 255.0,
							"g": 255.0
						},
						"Idx": 9.0,
						"Num": 4.0,
						"Type": "VECTOR"
					},
					"Green": {
						"Name": "Green",
						"Material": "tripmine_laser",
						"Width": 1.0,
						"Value": 0.0,
						"Color": {
							"r": 255.0,
							"b": 255.0,
							"a": 255.0,
							"g": 255.0
						},
						"Idx": 7.0,
						"Num": 2.0,
						"Type": "NORMAL"
					},
					"On": {
						"Path": [
							{
								"Pos": "[-0.0313 0.0313 -0.25]"
							}
						],
						"SrcId": "FL",
						"Name": "On",
						"Num": 8.0,
						"Material": "cable/cable2",
						"Width": 0.0,
						"Value": 0.0,
						"Color": {
							"r": 255.0,
							"b": 255.0,
							"a": 255.0,
							"g": 255.0
						},
						"Idx": 13.0,
						"StartPos": "[1.9688 0.4063 -0.0938]",
						"Type": "NORMAL"
					},
					"Blue": {
						"Name": "Blue",
						"Material": "tripmine_laser",
						"Width": 1.0,
						"Value": 0.0,
						"Color": {
							"r": 255.0,
							"b": 255.0,
							"a": 255.0,
							"g": 255.0
						},
						"Idx": 8.0,
						"Num": 3.0,
						"Type": "NORMAL"
					},
					"FOV": {
						"Name": "FOV",
						"Material": "tripmine_laser",
						"Width": 1.0,
						"Value": 0.0,
						"Color": {
							"r": 255.0,
							"b": 255.0,
							"a": 255.0,
							"g": 255.0
						},
						"Idx": 10.0,
						"Num": 5.0,
						"Type": "NORMAL"
					},
					"Red": {
						"Name": "Red",
						"Material": "tripmine_laser",
						"Width": 1.0,
						"Value": 0.0,
						"Color": {
							"r": 255.0,
							"b": 255.0,
							"a": 255.0,
							"g": 255.0
						},
						"Idx": 6.0,
						"Num": 1.0,
						"Type": "NORMAL"
					},
					"Distance": {
						"Name": "Distance",
						"Material": "tripmine_laser",
						"Width": 1.0,
						"Value": 0.0,
						"Color": {
							"r": 255.0,
							"b": 255.0,
							"a": 255.0,
							"g": 255.0
						},
						"Idx": 11.0,
						"Num": 6.0,
						"Type": "NORMAL"
					},
					"Brightness": {
						"Name": "Brightness",
						"Material": "tripmine_laser",
						"Width": 1.0,
						"Value": 0.0,
						"Color": {
							"r": 255.0,
							"b": 255.0,
							"a": 255.0,
							"g": 255.0
						},
						"Idx": 12.0,
						"Num": 7.0,
						"Type": "NORMAL"
					},
					"Texture": {
						"Name": "Texture",
						"Material": "tripmine_laser",
						"Width": 1.0,
						"Value": "",
						"Color": {
							"r": 255.0,
							"b": 255.0,
							"a": 255.0,
							"g": 255.0
						},
						"Idx": 14.0,
						"Num": 9.0,
						"Type": "STRING"
					}
				},
				"Class": "gmod_wire_lamp",
				"ColGroup": 20.0,
				"Maxs": "[2.2754 0.5153 0.5156]",
				"IsWire": true,
				"Skin": 0.0,
				"Angle": "{-0.0072 -0.0073 -0.0002}",
				"Texture": "effects/flashlight001",
				"Model": "models/maxofs2d/lamp_flashlight.mdl",
				"FounderIndex": "1",
				"FOV": 90.0,
				"Spawnable": false,
				"b": 255.0,
				"Instructions": "",
				"RenderGroup": 9.0,
				"FlexScale": 1.0,
				"LINK_STATUS_UNLINKED": 1.0,
				"Author": "",
				"Folder": "entities/gmod_wire_lamp",
				"Type": "anim",
				"LINK_STATUS_ACTIVATED": 3.0,
				"Name": "",
				"g": 255.0,
				"ClassName": "gmod_wire_lamp",
				"LINK_STATUS_ACTIVE": 3.0,
				"LINK_STATUS_DEACTIVATED": 2.0,
				"Purpose": "Base for all wired SEnts",
				"SolidMod": false,
				"_children": [],
				"LINK_STATUS_LINKED": 2.0,
				"Constraints": [],
				"Mins": "[-4.2931 -0.5156 -0.5156]",
				"dt": [],
				"on": false,
				"Pos": "[8.2827 0.0411 3.7496]",
				"FounderSID": "76561198340016549"
			},
			"105": {
				"Skin": 0.0,
				"_DuplicatedMaterial": "phoenix_storms/metalset_1-2",
				"ColGroup": 20.0,
				"Health": 0.0,
				"SolidMod": false,
				"_children": [],
				"PhysicsObjects": {
					"0": {
						"Pos": "[9.9331 -0.2981 5.6803]",
						"Frozen": true,
						"Angle": "{-0.0272 -179.9824 135.0249}"
					}
				},
				"FlexScale": 1.0,
				"Maxs": "[2.1527 0.608 1.2887]",
				"EntityMods": {
					"colour": {
						"Color": {
							"r": 125.0,
							"b": 125.0,
							"a": 255.0,
							"g": 125.0
						},
						"RenderFX": 0.0,
						"RenderMode": 0.0
					},
					"material": {
						"MaterialOverride": "phoenix_storms/metalset_1-2"
					},
					"advr": [
						0.44999998807907107,
						0.44999998807907107,
						0.5199999809265137,
						0.44999998807907107,
						0.44999998807907107,
						0.5199999809265137,
						false
					]
				},
				"Constraints": [],
				"Mins": "[-1.923 -0.608 -0.1573]",
				"Name": "",
				"Pos": "[9.9331 -0.2981 5.6803]",
				"_DuplicatedColor": {
					"r": 125.0,
					"b": 125.0,
					"a": 255.0,
					"g": 125.0
				},
				"Class": "prop_physics",
				"Model": "models/items/ar2_grenade.mdl",
				"Angle": "{-0.0272 -179.9824 135.0249}"
			},
			"114": {
				"Skin": 0.0,
				"ColGroup": 0.0,
				"Health": 0.0,
				"SolidMod": false,
				"_children": [],
				"PhysicsObjects": {
					"0": {
						"Pos": "[0 0 0]",
						"Frozen": true,
						"Angle": "{0 0 0}"
					}
				},
				"FlexScale": 1.0,
				"Maxs": "[7.2531 1.4212 7.1486]",
				"EntityMods": {
					"colour": {
						"Color": {
							"r": 108.0,
							"b": 108.0,
							"a": 255.0,
							"g": 108.0
						},
						"RenderFX": 0.0,
						"RenderMode": 0.0
					}
				},
				"Constraints": [],
				"Mins": "[-3.7587 -2.1051 -0.1845]",
				"Name": "",
				"Pos": "[0 0 0]",
				"_DuplicatedColor": {
					"r": 108.0,
					"b": 108.0,
					"a": 255.0,
					"g": 108.0
				},
				"Class": "prop_physics",
				"Model": "models/weapons/w_pist_usp.mdl",
				"Angle": "{0 0 0}"
			},
			"112": {
				"Skin": 0.0,
				"_DuplicatedMaterial": "phoenix_storms/dome",
				"ColGroup": 20.0,
				"Health": 0.0,
				"SolidMod": false,
				"_children": [],
				"PhysicsObjects": {
					"0": {
						"Pos": "[6.4768 0.0002 4.7478]",
						"Frozen": true,
						"Angle": "{-0.0248 -90.0221 -179.9874}"
					}
				},
				"FlexScale": 1.0,
				"Maxs": "[0.5635 3.3168 4.0301]",
				"EntityMods": {
					"colour": {
						"Color": {
							"r": 54.0,
							"b": 54.0,
							"a": 255.0,
							"g": 54.0
						},
						"RenderFX": 0.0,
						"RenderMode": 0.0
					},
					"material": {
						"MaterialOverride": "phoenix_storms/dome"
					},
					"advr": [
						0.18000000715255738,
						0.3499999940395355,
						0.3499999940395355,
						0.18000000715255738,
						0.3499999940395355,
						0.3499999940395355,
						false
					]
				},
				"Constraints": [],
				"Mins": "[-0.5635 -3.2827 -0.098]",
				"Name": "",
				"Pos": "[6.4768 0.0002 4.7478]",
				"_DuplicatedColor": {
					"r": 54.0,
					"b": 54.0,
					"a": 255.0,
					"g": 54.0
				},
				"Class": "prop_physics",
				"Model": "models/items/boxsrounds.mdl",
				"Angle": "{-0.0248 -90.0221 -179.9874}"
			},
			"83": {
				"Skin": 0.0,
				"ColGroup": 20.0,
				"Health": 0.0,
				"SolidMod": false,
				"_children": [],
				"PhysicsObjects": {
					"0": {
						"Pos": "[10.7531 0.0435 5.535]",
						"Frozen": true,
						"Angle": "{-89.9586 -0.0201 0}"
					}
				},
				"FlexScale": 1.0,
				"Maxs": "[1.1423 0.8476 5.3593]",
				"EntityMods": {
					"colour": {
						"Color": {
							"r": 108.0,
							"b": 108.0,
							"a": 255.0,
							"g": 108.0
						},
						"RenderFX": 0.0,
						"RenderMode": 0.0
					},
					"advr": [
						0.44999998807907107,
						0.3400000035762787,
						0.5199999809265137,
						0.44999998807907107,
						0.3400000035762787,
						0.5199999809265137,
						false
					]
				},
				"Constraints": [],
				"Mins": "[-1.9477 -0.8635 -0.1438]",
				"Name": "",
				"Pos": "[10.7531 0.0435 5.535]",
				"_DuplicatedColor": {
					"r": 108.0,
					"b": 108.0,
					"a": 255.0,
					"g": 108.0
				},
				"Class": "prop_physics",
				"Model": "models/items/battery.mdl",
				"Angle": "{-89.9586 -0.0201 0}"
			},
			"110": {
				"ColGroup": 20.0,
				"PhysicsObjects": {
					"0": {
						"Pos": "[9.5622 0.0101 2.025]",
						"Frozen": true,
						"Angle": "{-89.9938 179.9924 0}"
					}
				},
				"out_ang": false,
				"out_uid": false,
				"out_pos": false,
				"Contact": "",
				"Class": "gmod_wire_ranger",
				"dt": [],
				"LINK_STATUS_ACTIVE": 3.0,
				"trace_water": false,
				"out_dist": true,
				"_DuplicatedMaterial": "phoenix_storms/metalfloor_2-3",
				"Health": 0.0,
				"Instructions": "",
				"out_col": false,
				"Type": "anim",
				"LINK_STATUS_ACTIVATED": 3.0,
				"ClassName": "gmod_wire_ranger",
				"Angle": "{-89.9919 179.9924 0}",
				"LINK_STATUS_LINKED": 2.0,
				"Mins": "[-1.0539 -0.4216 -0.025]",
				"Pos": "[9.5622 0.0101 2.025]",
				"out_eid": false,
				"Base": "base_wire_entity",
				"PrintName": "Wire Ranger",
				"hires": false,
				"LINK_STATUS_INACTIVE": 2.0,
				"AdminOnly": false,
				"DT": {
					"SkewY": 0.0,
					"ShowBeam": true,
					"SkewX": 0.0,
					"Target": "[0 0 0]",
					"BeamLength": 1500.0
				},
				"IsWire": true,
				"Outputs": {
					"Dist": {
						"Connected": [],
						"Idx": 1.0,
						"TriggerLimit": 3.0,
						"Num": 1.0,
						"Value": 0.0,
						"TriggerTime": 428.66998291015627,
						"Name": "Dist",
						"Type": "NORMAL"
					},
					"RangerData": {
						"TriggerTime": 433.125,
						"Idx": 2.0,
						"Num": 2.0,
						"Value": {
							"HitBox": 0.0,
							"HitNonWorld": false,
							"HitGroup": 0.0,
							"HitPos": "[798.2974 -822.28 -110.6348]",
							"Contents": 0.0,
							"FractionLeftSolid": 0.0,
							"StartSolid": false,
							"Hit": false,
							"RealStartPos": "[797.8156 677.7198 -110.6095]",
							"HitWorld": false,
							"Normal": "[0.0003 -1 -0]",
							"SurfaceProps": 0.0,
							"HitTexture": "**empty**",
							"Fraction": 1.0,
							"HitSky": false,
							"PhysicsBone": 0.0,
							"SurfaceFlags": 0.0,
							"HitNormal": "[0 0 0]",
							"DispFlags": 0.0,
							"AllSolid": false,
							"StartPos": "[797.8156 677.7198 -110.6095]",
							"HitNoDraw": false
						},
						"Type": "RANGER",
						"Connected": [],
						"Name": "RangerData",
						"TriggerLimit": 3.0
					}
				},
				"Skin": 0.0,
				"_DuplicatedColor": {
					"r": 108.0,
					"b": 0.0,
					"a": 255.0,
					"g": 0.0
				},
				"FounderSID": "76561198340016549",
				"FounderIndex": "1",
				"out_hnrm": false,
				"out_vel": false,
				"FlexScale": 1.0,
				"Maxs": "[1.0539 0.4216 1.1561]",
				"EntityMods": {
					"colour": {
						"Color": {
							"r": 108.0,
							"b": 0.0,
							"a": 255.0,
							"g": 0.0
						},
						"RenderFX": 0.0,
						"RenderMode": 0.0
					},
					"material": {
						"MaterialOverride": "phoenix_storms/metalfloor_2-3"
					},
					"advr": [
						0.25,
						0.10000000149011612,
						0.10000000149011612,
						0.25,
						0.10000000149011612,
						0.10000000149011612,
						false
					],
					"WireDupeInfo": {
						"Wires": []
					}
				},
				"Folder": "entities/gmod_wire_ranger",
				"Name": "",
				"Constraints": [],
				"LINK_STATUS_UNLINKED": 1.0,
				"out_sid": false,
				"LINK_STATUS_DEACTIVATED": 2.0,
				"IsMotionControlled": true,
				"Purpose": "Base for all wired SEnts",
				"SolidMod": false,
				"_children": [],
				"show_beam": true,
				"Spawnable": false,
				"default_zero": true,
				"Author": "",
				"RenderGroup": 9.0,
				"Model": "models/jaanus/wiretool/wiretool_beamcaster.mdl",
				"out_val": false,
				"Inputs": {
					"SelectValue": {
						"Name": "SelectValue",
						"Material": "tripmine_laser",
						"Width": 1.0,
						"Value": 0.0,
						"Color": {
							"r": 255.0,
							"b": 255.0,
							"a": 255.0,
							"g": 255.0
						},
						"Idx": 3.0,
						"Num": 3.0,
						"Type": "NORMAL"
					},
					"X": {
						"Name": "X",
						"Material": "tripmine_laser",
						"Width": 1.0,
						"Value": 0.0,
						"Color": {
							"r": 255.0,
							"b": 255.0,
							"a": 255.0,
							"g": 255.0
						},
						"Idx": 1.0,
						"Num": 1.0,
						"Type": "NORMAL"
					},
					"Y": {
						"Name": "Y",
						"Material": "tripmine_laser",
						"Width": 1.0,
						"Value": 0.0,
						"Color": {
							"r": 255.0,
							"b": 255.0,
							"a": 255.0,
							"g": 255.0
						},
						"Idx": 2.0,
						"Num": 2.0,
						"Type": "NORMAL"
					},
					"Length": {
						"Name": "Length",
						"Material": "tripmine_laser",
						"Width": 1.0,
						"Value": 0.0,
						"Color": {
							"r": 255.0,
							"b": 255.0,
							"a": 255.0,
							"g": 255.0
						},
						"Idx": 4.0,
						"Num": 4.0,
						"Type": "NORMAL"
					},
					"Target": {
						"Name": "Target",
						"Material": "tripmine_laser",
						"Width": 1.0,
						"Value": "[0 0 0]",
						"Color": {
							"r": 255.0,
							"b": 255.0,
							"a": 255.0,
							"g": 255.0
						},
						"Idx": 5.0,
						"Num": 5.0,
						"Type": "VECTOR"
					}
				},
				"ignore_world": true
			},
			"113": {
				"inc_files": [],
				"Base": "base_wire_entity",
				"ColGroup": 20.0,
				"funcs_ret": [],
				"PhysicsObjects": {
					"0": {
						"Pos": "[-0.316 0.8114 4.3465]",
						"NoGrav": true,
						"Sleep": true,
						"Frozen": true,
						"Angle": "{89.9808 90 0}"
					}
				},
				"Maxs": "[0.5 0.5 0.25]",
				"globvars": [],
				"Spawnable": false,
				"_vars": {
					"lookup": [],
					"FL": 0.0,
					"vclk": []
				},
				"PrintName": "Wire Expression 2",
				"Contact": "me@syranide.com",
				"_inputs": [
					[],
					[]
				],
				"trigger": [
					true,
					[]
				],
				"persists": [
					[],
					[],
					[]
				],
				"context": {
					"Scope": {
						"lookup": [],
						"FL": 0.0,
						"vclk": []
					},
					"funcs_ret": [],
					"ScopeID": 0.0,
					"uid": "1",
					"vclk": [],
					"timebench": 0.00001293995786466018,
					"time": 0.0,
					"includes": [],
					"funcs": [],
					"prfcount": 0.0,
					"prf": 0.0,
					"strfunc_cache": [
						[],
						[]
					],
					"prfbench": 24.60101856318376,
					"triggercache": [],
					"data": {
						"EGP": {
							"UpdatesNeeded": [],
							"RunOnEGP": []
						},
						"find": {
							"wl_entity": [],
							"bl_class": [],
							"wl_model": [],
							"wl_owner": [],
							"bl_owner": [],
							"wl_class": [],
							"bl_entity": [],
							"bl_model": []
						},
						"rangerignoreworld": false,
						"gvars": {
							"shared": 0.0,
							"group": "default"
						},
						"rangerpersist": false,
						"signalgroup": "default",
						"effect_burst": 4.0,
						"rangerfilter_lookup": [],
						"findcount": 10.0,
						"sound_data": {
							"burst": 8.0,
							"count": 0.0,
							"sounds": []
						},
						"spawnedProps": [],
						"rangerwhitelistmode": false,
						"constraintUndos": true,
						"rangerentities": true,
						"propSpawnEffect": true,
						"findnext": 0.0,
						"datasignal": {
							"groups": [],
							"scope": 0.0
						},
						"propSpawnUndo": true,
						"changed": [],
						"holo": {
							"remainingSpawns": 80.0,
							"nextSpawn": 428.5899963378906,
							"nextBurst": 437.5899963378906
						},
						"rangerwater": false,
						"findlist": [],
						"rangerdefaultzero": false,
						"rangerfilter": [],
						"timer": {
							"timerid": 0.0,
							"timers": {
								"interval": true
							}
						},
						"holos": []
					},
					"trace": [
						17.0,
						1.0
					],
					"GlobalScope": {
						"lookup": [],
						"FL": 0.0,
						"vclk": []
					},
					"Scopes": {
						"0": {
							"lookup": [],
							"FL": 0.0,
							"vclk": []
						}
					}
				},
				"LINK_STATUS_INACTIVE": 2.0,
				"AdminOnly": false,
				"GlobalScope": {
					"lookup": [],
					"FL": 0.0,
					"vclk": []
				},
				"first": false,
				"buffer": "\n\n\n\n\n\n\n\ninterval(50)\n\n\n\n\n\nlocal Wep = getNSPWRelatedWeapon(entity())\n\nif(Wep:isValid())\n{\n    local Owner = Wep:owner()\n    if(Owner:isFlashlightOn())\n    {\n        FL = 1\n    }\n    else\n    {\n        FL = 0\n    }\n}\n\n",
				"Class": "gmod_wire_expression2",
				"includes": [],
				"IsWire": true,
				"name": "nspw_gun_idioticpistolv1_chip",
				"_outputs": [
					[
						"FL"
					],
					[
						"NORMAL"
					]
				],
				"Outputs": {
					"FL": {
						"Type": "NORMAL",
						"Connected": [
							{
								"Name": "On"
							}
						],
						"Idx": 3.0,
						"TriggerLimit": 8.0,
						"Value": 0.0,
						"Name": "FL",
						"Num": 1.0
					}
				},
				"SolidMod": false,
				"Model": "models/expression 2/cpu_processor_nano.mdl",
				"script": [
					39.5,
					{
						"2": {
							"TraceName": "LITERAL",
							"Trace": [
								9.0,
								10.0
							]
						},
						"3": [
							"n"
						],
						"TraceName": "CALL",
						"Trace": [
							9.0,
							1.0
						]
					},
					{
						"2": "Wep",
						"3": {
							"2": {
								"2": [],
								"TraceName": "CALL",
								"Trace": [
									15.0,
									34.0
								]
							},
							"3": [
								"e"
							],
							"TraceName": "CALL",
							"Trace": [
								15.0,
								13.0
							]
						},
						"4": 1.0,
						"TraceName": "ASSL",
						"Trace": [
							15.0,
							7.0
						]
					},
					{
						"2": 11.0,
						"3": [
							{
								"2": {
									"TraceName": "VAR",
									"Trace": [
										17.0,
										4.0
									]
								},
								"3": [],
								"TraceName": "METHODCALL",
								"Trace": [
									17.0,
									8.0
								]
							}
						],
						"4": {
							"2": 14.0,
							"3": {
								"2": "Owner",
								"3": {
									"2": {
										"TraceName": "VAR",
										"Trace": [
											19.0,
											19.0
										]
									},
									"3": [],
									"TraceName": "METHODCALL",
									"Trace": [
										19.0,
										23.0
									]
								},
								"4": 2.0,
								"TraceName": "ASSL",
								"Trace": [
									19.0,
									11.0
								]
							},
							"4": {
								"2": 6.0,
								"3": [
									{
										"2": {
											"TraceName": "VAR",
											"Trace": [
												20.0,
												8.0
											]
										},
										"3": [],
										"TraceName": "METHODCALL",
										"Trace": [
											20.0,
											14.0
										]
									}
								],
								"4": {
									"2": 2.5,
									"3": {
										"2": "FL",
										"3": {
											"TraceName": "LITERAL",
											"Trace": [
												22.0,
												14.0
											]
										},
										"4": 0.0,
										"TraceName": "ASS",
										"Trace": [
											22.0,
											9.0
										]
									},
									"TraceName": "SEQ",
									"Trace": [
										20.0,
										30.0
									]
								},
								"5": {
									"2": 2.5,
									"3": {
										"2": "FL",
										"3": {
											"TraceName": "LITERAL",
											"Trace": [
												26.0,
												14.0
											]
										},
										"4": 0.0,
										"TraceName": "ASS",
										"Trace": [
											26.0,
											9.0
										]
									},
									"TraceName": "SEQ",
									"Trace": [
										24.0,
										5.0
									]
								},
								"TraceName": "IF",
								"Trace": [
									20.0,
									5.0
								]
							},
							"TraceName": "SEQ",
							"Trace": [
								17.0,
								17.0
							]
						},
						"5": {
							"2": 0.0,
							"TraceName": "SEQ",
							"Trace": [
								28.0,
								1.0
							]
						},
						"TraceName": "IF",
						"Trace": [
							17.0,
							1.0
						]
					}
				],
				"tvars": [],
				"Skin": 0.0,
				"FounderSID": "76561198340016549",
				"Type": "anim",
				"LINK_STATUS_ACTIVE": 3.0,
				"Health": 0.0,
				"EntityMods": {
					"WireDupeInfo": {
						"Wires": []
					}
				},
				"LINK_STATUS_DEACTIVATED": 2.0,
				"uid": "1",
				"RenderGroup": 7.0,
				"FlexScale": 1.0,
				"LINK_STATUS_UNLINKED": 1.0,
				"LINK_STATUS_ACTIVATED": 3.0,
				"Author": "Syranide",
				"Folder": "entities/gmod_wire_expression2",
				"funcs": [],
				"dvars": [],
				"Name": "",
				"error": false,
				"Inputs": [],
				"ClassName": "gmod_wire_expression2",
				"filepath": "expression2/nspw_gun_idioticpistolv1_chip.txt",
				"lastResetOrError": 427.5899963378906,
				"Angle": "{89.9811 90 0}",
				"original": "@name nspw_gun_idioticpistolv1_chip\n@inputs \n@outputs FL\n@persist \n@trigger \n@strict\n\n# No tick,plz\ninterval(50)\n\n#Marked as \"listening to some idiotic hooks\"\n\n#runOnNSPWEvent(1)\n#weapon entity\nlocal Wep = getNSPWRelatedWeapon(entity())\n\nif(Wep:isValid())\n{\n    local Owner = Wep:owner()\n    if(Owner:isFlashlightOn())\n    {\n        FL = 1\n    }\n    else\n    {\n        FL = 0   \n    }\n}\n\n",
				"outports": [
					[
						"FL"
					],
					[
						"NORMAL"
					],
					{
						"FL": "NORMAL"
					},
					[]
				],
				"Instructions": "",
				"FounderIndex": "1",
				"Purpose": "",
				"LINK_STATUS_LINKED": 2.0,
				"_original": "@name nspw_gun_idioticpistolv1_chip€@inputs €@outputs FL€@persist €@trigger €@strict€€# No tick,plz€interval(50)€€#Marked as £listening to some idiotic hooks£€€#runOnNSPWEvent(1)€#weapon entity€local Wep = getNSPWRelatedWeapon(entity())€€if(Wep:isValid())€{€    local Owner = Wep:owner()€    if(Owner:isFlashlightOn())€    {€        FL = 1€    }€    else€    {€        FL = 0   €    }€}€€",
				"duped": false,
				"Mins": "[-0.5239 -0.5 -0.25]",
				"inports": [
					[],
					[],
					[],
					[]
				],
				"Pos": "[-0.316 0.8114 4.3346]",
				"_name": "nspw_gun_idioticpistolv1_chip",
				"directives": {
					"trigger": [
						true,
						[]
					],
					"inputs": [
						[],
						[],
						[],
						[]
					],
					"strict": true,
					"persist": [
						[],
						[],
						[]
					],
					"outputs": [
						[
							"FL"
						],
						[
							"NORMAL"
						],
						{
							"FL": "NORMAL"
						},
						[]
					],
					"name": "nspw_gun_idioticpistolv1_chip",
					"delta": [
						[],
						[],
						[]
					]
				}
			}
		}
	},
	"DupeDataC": 114.0,
	"PropData": {
		"BulletSpread": "{0 0.8 0.8}",
		"BulletDamageOffset": 4.0,
		"ReloadSpeedAffectMul": 1.0,
		"TrueRecoilMul_Offset": 0.05,
		"MuzzlePos": "[0 0 4]",
		"OffsetPos": "[1 0.8 2]",
		"BulletCount": 1.0,
		"ReloadEvent_LoadGun": "weapons/usp/usp_sliderelease.wav",
		"Priority": 3.0,
		"ReloadEvent_ClipIn": "weapons/usp/usp_clipin.wav",
		"ReloadEvent_ClipOut": "weapons/usp/usp_clipout.wav",
		"RecoilV_Offset": 0.3,
		"BulletDamage": 11.0,
		"RecoilV": 0.0,
		"Magsize": 12.0,
		"ReloadSpeedMul": 1.0,
		"AmmoType": "pistol",
		"IsGun": true,
		"RecoilH_Offset": 0.15,
		"RecoilH": 0.35,
		"NoAim": false,
		"ShootSound": "weapons/usp/usp_unsil-1.wav",
		"TrueRecoilMul": 0.15,
		"OffsetAng": "{10.6 -0.5 -2}",
		"AttackDamageType": 128.0,
		"BulletDamageType": 2.0
	}
}]])