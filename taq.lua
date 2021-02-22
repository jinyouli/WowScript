function TAQHandle()

    AK.Dungeon.step = "init"
    AK.Dungeon.sendonry_step = "init"
    AK.Dungeon.path_corps = nil
    AK.Dungeon.path_index = 0
    AK.Dungeon.second_path_index = 0
    AK.Dungeon.second_path_index_two = 1
    AK.Dungeon.eyun_dead_point_start = {-4580.6342,1631.246,94.1163}
    AK.Dungeon.eyun_dead_point_real = {320.33,11.213,-9.30}
    AK.Dungeon.eyun_dead_point_enter = {-3957.44,1079.9622,161.1315}

    AK.Dungeon.boss_path_index = 1
    AK.Dungeon.eyun_go_boss_path = {
      {254.9199,-19.4629,-2.5596},
      {278.2481,-22.6146,-2.5596},
      {311.8697,12.6752,-3.8855}
    }

    AK.Dungeon.eyun_go_boss_path_up = {
      {314.8999,11.6153,-1.5010},
      {320.6407,11.5291,-1.6598}
    }

    AK.Dungeon.eyun_go_boss_path_one = {
      {294.0,-16.486,-3.886},
      {314.0058,11.4703,-5.8029},
      {314.97134399414,-0.78615522,-5.1237}
      }

    AK.Dungeon.eyun_go_boss_path_two = {
      {322.1308,15.2002,-1.2854},
      {322.2892,26.3093,-1.2878},
      {322.1133,49.7534,-1.2882},
      {322.2793,52.1980,-1.2883},
      {322.3699,65.0776,-1.2883},
      {322.3987,69.1713,-1.2878},
      {322.5786,94.7569,-1.2875}
      }

    AK.Dungeon.dead_go_dungeon_path = {
      {-4565.48,1616.783,95.76},
      {-4549.226,1581.98,102.1901},
      {-4495.95,1550.376,126.04},
      {-4442.08,1534.6671,127.2231},
      {-4441.188,1519.089,126.575},
      {-4431.73876,1506.1911,127.389},
      {-4411.3945,1530.09,133.2334},
      {-4407.575683,1524.0577,135.213},
      {-4401.496,1526.30,136.954},
      {-4399.253,1524.473,139.08},
      {-4398.6347,1518.41,145.674},
      {-4397.1225,1515.4473,149.50906},
      {-4395.64990,1515.55615,150.610336},
      {-4373.5761,1507.8056,150.6071},
      {-4349.4458,1425.4608,150.6068},
      {-4342.6767,1336.9954,159.2350},
      {-4188.4804,1327.9238,161.2135},
      {-4170.6938,1139.3192,161.2134},
      {-4039.4980,1136.2711,159.7444},
      {-4032.87,1072.3548,159.7126},
      {-3985.7402,1066.368,161.0472},
      {-3982.2937,1117.7230,161.023},
      {-3876.5849,1136.3740,154.788},
      {-3798.4731,1155.450,154.788467},
      {-3780.41,1173.005,154.78},
      {-3720.568,1165.118,154.787},
      {-3682.7114257,1143.55,154.7871},
      {-3526.3627,1123.5355,161.0235},
      {-3519.6892,1078.21130,161.141},
      {-3520,1062,161.1}
    }


    AK.Dungeon.MainHandle = function()

          if AK.API.IsPlayerDead() and  AK.Dungeon.step ~= "dead" then
             AK.Dungeon.step,AK.Dungeon.sendonry_step = "dead","init"
          end

          if AK.Dungeon.step == "init" and AK.Dungeon.sendonry_step == "init" then
              AK.Dungeon.step,AK.Dungeon.sendonry_step = "go_boss","init"
          elseif AK.Dungeon.step == "dead" then
              AK.Dungeon.step,AK.Dungeon.sendonry_step = AK.Dungeon.DeadHandle(AK.Dungeon.step,AK.Dungeon.sendonry_step)
          elseif AK.Dungeon.step == "go_boss" then
              AK.Dungeon.step,AK.Dungeon.sendonry_step = AK.Dungeon.GoBossHandle(AK.Dungeon.step,AK.Dungeon.sendonry_step)
              
          end 
    end


    AK.Dungeon.GoBossHandle = function(step,sendonry_step)
      -- wmbapi.SetClimbAngle()
      local targetX = AK.Dungeon.eyun_go_boss_path_one[2][1];
      local targetY = AK.Dungeon.eyun_go_boss_path_one[2][2];
      local targetZ = AK.Dungeon.eyun_go_boss_path_one[2][3];
      local PlayerX, PlayerY, PlayerZ = ObjectPosition("Player");

      if AK.Dungeon.sendonry_step == "init" then 
          -- AK.Me.SetDelayCount(20)
          AK.API.MoveTo(264.9318237,-27.3486,-2.559)
          return "go_boss","step_point_1"
      elseif AK.Dungeon.sendonry_step == "step_point_1" then 
          -- AK.Me.SetDelayCount(15)
          AK.API.MoveTo(269.79,-24.99,-2.559)
          AK.Me.SetDelayCount(30)

          return "go_boss","step_point_2"
      elseif AK.Dungeon.sendonry_step == "step_point_2" then
        --监测周边怪物，准备去台子处
        
        npcNum = wmbapi.GetNpcCount(PlayerX, PlayerY, PlayerZ, 50, 0)
        local enemyNum = 0
        local isPass = true
        local distance = 100000000

        for i=1,npcNum do
          npc = wmbapi.GetNpcWithIndex(i)
          isEnemy = UnitIsEnemy("player",npc)
          if isEnemy == true then
            enemyNum = enemyNum + 1

              local x, y, z = wmbapi.ObjectPosition(npc)
              flags = UnitMovementFlags(npc)
              dis_player = GetDistanceBetweenPositions(x,y,z, PlayerX, PlayerY, PlayerZ)

              if flags > 0 and dis_player < distance then
                enemyNum = i
                distance = dis_player
              end

              if GetDistanceBetweenPositions(x,y,z, targetX, targetY, targetZ) < 45 or dis_player < 45 then
                isPass = false
              end
            end
          end
      
        if isPass == false then
          return "go_boss","step_point_2"
        end

        if enemyNum ~= 0 then
          npc = wmbapi.GetNpcWithIndex(enemyNum)

          local x, y, z = wmbapi.ObjectPosition(npc)
          flags = UnitMovementFlags(npc)
          isFace = ObjectIsFacing(npc, "player")
          facing = wmbapi.ObjectFacing(npc)

          if GetDistanceBetweenPositions(PlayerX,PlayerY,PlayerZ, x, y, z) < 45 or isFace or facing < 3.9 then
            isPass = false
          end

          if isPass == true then
            AK.Me.SetDelayCount(60)
            AK.API.MoveTo(AK.Dungeon.eyun_go_boss_path_one[1][1],AK.Dungeon.eyun_go_boss_path_one[1][2],AK.Dungeon.eyun_go_boss_path_one[1][3])
            C_Timer.After(3, function()
            AK.API.MoveTo(AK.Dungeon.eyun_go_boss_path_one[3][1],AK.Dungeon.eyun_go_boss_path_one[3][2],AK.Dungeon.eyun_go_boss_path_one[3][3])
            end)
            return "go_boss","step_point_3"   
          end
        end
       return "go_boss","step_point_2"
     
      elseif AK.Dungeon.sendonry_step == "step_point_3" then

        if GetDistanceBetweenPositions(PlayerX,PlayerY,PlayerZ, targetX, targetY, targetZ) < 2 then
          return "go_boss","step_point_4"
        else
          AK.API.MoveTo(targetX, targetY, targetZ)
          return "go_boss","step_point_3"
        end
      elseif AK.Dungeon.sendonry_step == "step_point_4" then
        -- AK.Me.SetDelayCount(30)

        if GetDistanceBetweenPositions(PlayerX,PlayerY,PlayerZ, targetX, targetY, targetZ) < 1 then
            return "go_boss","step_point_5"
        else
          AK.API.MoveTo(targetX, targetY, targetZ)
          return "go_boss","step_point_4"
        end 
        
      elseif AK.Dungeon.sendonry_step == "step_point_5" then
        wmbapi.SetClimbAngle(90)
        AK.Me.SetDelayCount(60)

        JumpOrAscendStart();
        MoveForwardStart()
        MoveForwardStop()
        AscendStop();

        C_Timer.After(2, function()
          JumpOrAscendStart();
          MoveForwardStart()
          MoveForwardStop()
          AscendStop();
        end)

        C_Timer.After(4, function()
          JumpOrAscendStart();
          MoveForwardStart()
          MoveForwardStop()
          AscendStop();
        end)


       return "go_boss","step_point_6"
      
      elseif AK.Dungeon.sendonry_step == "step_point_6" then
       
       wmbapi.FaceDirection(0)
       AK.Me.SetDelayCount(10)

       JumpOrAscendStart();
       MoveForwardStart()


       C_Timer.After(1, function()
          
          MoveForwardStop()
          AscendStop();
        end)

         return "go_boss","step_point_7"

      elseif AK.Dungeon.sendonry_step == "step_point_7" then
          wmbapi.SetClimbAngle()

          local destX = AK.Dungeon.eyun_go_boss_path_two[AK.Dungeon.second_path_index_two][1]
          local destY = AK.Dungeon.eyun_go_boss_path_two[AK.Dungeon.second_path_index_two][2]
          local destZ = AK.Dungeon.eyun_go_boss_path_two[AK.Dungeon.second_path_index_two][3]

          local toX = AK.Dungeon.eyun_go_boss_path_two[#AK.Dungeon.eyun_go_boss_path_two][1]
          local toY = AK.Dungeon.eyun_go_boss_path_two[#AK.Dungeon.eyun_go_boss_path_two][2]
          local toZ = AK.Dungeon.eyun_go_boss_path_two[#AK.Dungeon.eyun_go_boss_path_two][3]
          local distance_gap = 2
          
          if GetDistanceBetweenPositions(PlayerX,PlayerY,PlayerZ,toX,toY,toZ) < distance_gap then
                StopMoving()
                MoveForwardStop()
                return "go_boss","end"
          end

          if GetDistanceBetweenPositions(PlayerX,PlayerY,PlayerZ,destX,destY,destZ) > distance_gap then

              AK.API.MoveTo(destX,destY,destZ)

              return "go_boss","step_point_7"
          else
              AK.Dungeon.second_path_index_two = AK.Dungeon.second_path_index_two + 1
              if AK.Dungeon.second_path_index_two > #AK.Dungeon.eyun_go_boss_path_two then
                  AK.Dungeon.second_path_index_two = 0
                  AK.Dungeon.eyun_go_boss_path_two = {}
                  return "go_boss","step_point_7"
              end
              return "go_boss","step_point_7"
          end

          return "go_boss","end"
      elseif AK.Dungeon.sendonry_step == "end" then
        print("到达!!!!")
      end
    end 
    


    AK.Dungeon.DeadHandle = function(step,sendonry_step)

          if not AK.API.IsPlayerDead() then
              return "init","init"
          end

          local PlayerX, PlayerY, PlayerZ = ObjectPosition("Player");

          if AK.Dungeon.sendonry_step == "init" then

              AK.Config.GM_Notice = false
              AK.Me.SetDelayCount(30)

              C_Timer.After(2, function()
                  RunMacroText("/click StaticPopup1Button1")
              end)

              return "dead","cal_dead_path"

          elseif AK.Dungeon.sendonry_step == "cal_dead_path" then
                local toX,toY,toZ = GetCorpsePosition()
                if GetDistanceBetweenPositions(-3908.0324,1130.0035,149.342,toX,toY,toZ) < 1 then
                    toX = AK.Dungeon.eyun_dead_point_real[1]
                    toY = AK.Dungeon.eyun_dead_point_real[2]
                    toZ = AK.Dungeon.eyun_dead_point_real[3]
                end 
                -- toX = -4580.6342
                -- toY = 1631.246
                -- toZ = 94.1163
                AK.Dungeon.path_corps  = AK.API.CalculatePath(GetMapId(), PlayerX, PlayerY, PlayerZ, toX, toY, toZ, true, true, 2.5)
                AK.Dungeon.second_path_index = 1
                AK.Dungeon.secondary_step = "path"
                local distance_gap = 2

                -- print("计算路径")
                -- print(AK.Dungeon.path_corps)
                if AK.Dungeon.path_corps == nil then
                    AK.Me.SetDelayCount(15000000)
                    print("无法计算出跑尸体的路径，请检查是否安装好了地图包或者是否存在障碍物")
                    print(toX.." "..toY.." "..toZ)
                    if GetDistanceBetweenPositions(AK.Dungeon.eyun_dead_point_real[1],AK.Dungeon.eyun_dead_point_real[2],AK.Dungeon.eyun_dead_point_real[3],toX,toY,toZ) < distance_gap then

                      AK.Dungeon.path_corps = AK.Dungeon.dead_go_dungeon_path
                      AK.Me.SetDelayCount(30)
                    end 
                    return "dead","path"
                end
                return "dead","path"

          elseif AK.Dungeon.sendonry_step == "path" then
                AK.Config.GM_Notice = false

                local destX = AK.Dungeon.path_corps[AK.Dungeon.second_path_index][1]
                local destY = AK.Dungeon.path_corps[AK.Dungeon.second_path_index][2]
                local destZ = AK.Dungeon.path_corps[AK.Dungeon.second_path_index][3]

                local toX,toY,toZ = GetCorpsePosition()
                -- toX = -4580.6342
                -- toY = 1631.246
                -- toZ = 94.1163
                local distance_gap = 2

                
                if GetDistanceBetweenPositions(PlayerX,PlayerY,destZ,toX,toY,toZ) < distance_gap then
                      StopMoving()
                      MoveForwardStop()
                      AK.API.MoveTo(ObjectPosition("player"))
                      return "dead","end"
                end

                if GetDistanceBetweenPositions(PlayerX,PlayerY,PlayerZ,destX,destY,destZ) > distance_gap then
                    -- print(destX.." "..destY.." "..destZ)

                    AK.API.MoveTo(destX,destY,destZ)

                    return "dead","path"
                else
                    AK.Dungeon.second_path_index = AK.Dungeon.second_path_index + 1
                    if AK.Dungeon.second_path_index > #AK.Dungeon.path_corps then
                        AK.Dungeon.second_path_index = 0
                        AK.Dungeon.path_corps = {}
                        return "dead","path"
                    end
                    return "dead","path"
                end

          elseif AK.Dungeon.sendonry_step == "end" then
                print("点击复活")
                AK.Me.SetDelayCount(10)
                RunMacroText("/click StaticPopup1Button1")
                RunMacroText("/click StaticPopup2Button1")
                AK.Dungeon.path_index = 0
                AK.Dungeon.second_path = {}
                AK.Dungeon.second_path_index = 0
                AK.Dungeon.path_corps = {}
                AK.CorpsX = nil
                AK.CorpsY = nil
                AK.CorpsZ = nil
                return "dead","end"

          end

    end

end

return {

};