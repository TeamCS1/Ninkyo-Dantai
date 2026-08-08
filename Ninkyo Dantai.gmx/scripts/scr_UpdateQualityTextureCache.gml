///scr_UpdateQualityTextureCache()
///Resolves every quality-switched texture ONCE, into globals the drawing
///objects read - instead of each of the ~1,700 affected instances calling
///sprite_get_texture in its Draw event every frame.
///
///Called every frame from obj_control's Begin Step, but the work only
///happens when a quality setting has actually changed: the guard below is
///four integer compares, and quality only changes when someone touches the
///options menu. Begin Step runs before every Draw event, so the globals are
///always current by the time anything reads them.
///
///THE ROOM-ENTRY RESET IS NOT OPTIONAL. obj_control's Create sets the four
///trackers to -1, forcing a rebuild on the first frame of every room. That
///is what keeps the cached pointers valid: texture pointers die when their
///texture page is unloaded, and cleanmem() runs on room transitions - a
///pointer cached in the city could be stale by the mall. Without the reset
///this whole cache is an intermittent white-model bug.
///
///ADDING A NEW QUALITY-SWITCHED OBJECT: add its five sprites to the right
///switch below and give it a global; do NOT put a sprite_get_texture
///switch back into its Draw event. The one deliberate exception is
///obj_oak_tree's within-64px transparent draw - cached here too, as
///global.texTransparent.

if (global.texCacheBuildingQ == global.buildingQuality)
&& (global.texCachePropsQ == global.propsQuality)
&& (global.texCacheEnvironmentQ == global.environmentQuality)
&& (global.texCacheTreeQ == global.treeQuality)
{
    exit;
}

global.texCacheBuildingQ = global.buildingQuality;
global.texCachePropsQ = global.propsQuality;
global.texCacheEnvironmentQ = global.environmentQuality;
global.texCacheTreeQ = global.treeQuality;

//Fixed textures, re-resolved here so they survive texture pages being
//flushed between rooms
global.texTransparent = sprite_get_texture(spr_transparent_texture_buruwasu, 0);

switch (global.buildingQuality)
{
    case 1:
        global.tex724ShopBlock = sprite_get_texture(spr_7_24_shop_block_64, 0);
        global.texElevator = sprite_get_texture(spr_elevator_64, 0);
        global.texHouseBlock001 = sprite_get_texture(spr_block_house_64_64, 0);
        global.texResidentialHouse = sprite_get_texture(spr_residential_house_64_64, 0);
        global.texWarehouse001 = sprite_get_texture(spr_warehouse_64, 0);
        break;

    case 2:
        global.tex724ShopBlock = sprite_get_texture(spr_7_24_shop_block_128, 0);
        global.texElevator = sprite_get_texture(spr_elevator_128, 0);
        global.texHouseBlock001 = sprite_get_texture(spr_block_house_128_128, 0);
        global.texResidentialHouse = sprite_get_texture(spr_residential_house_128_128, 0);
        global.texWarehouse001 = sprite_get_texture(spr_warehouse_128, 0);
        break;

    case 3:
        global.tex724ShopBlock = sprite_get_texture(spr_7_24_shop_block_256, 0);
        global.texElevator = sprite_get_texture(spr_elevator_256, 0);
        global.texHouseBlock001 = sprite_get_texture(spr_block_house_256_256, 0);
        global.texResidentialHouse = sprite_get_texture(spr_residential_house_256_256, 0);
        global.texWarehouse001 = sprite_get_texture(spr_warehouse_256, 0);
        break;

    case 4:
        global.tex724ShopBlock = sprite_get_texture(spr_7_24_shop_block_512, 0);
        global.texElevator = sprite_get_texture(spr_elevator_512, 0);
        global.texHouseBlock001 = sprite_get_texture(spr_block_house_512_512, 0);
        global.texResidentialHouse = sprite_get_texture(spr_residential_house_512_512, 0);
        global.texWarehouse001 = sprite_get_texture(spr_warehouse_512, 0);
        break;

    case 5:
        global.tex724ShopBlock = sprite_get_texture(spr_7_24_shop_block_1024, 0);
        global.texElevator = sprite_get_texture(spr_elevator_1024, 0);
        global.texHouseBlock001 = sprite_get_texture(spr_block_house_1024_1024, 0);
        global.texResidentialHouse = sprite_get_texture(spr_residential_house_1024_1024, 0);
        global.texWarehouse001 = sprite_get_texture(spr_warehouse_1024, 0);
        break;

}

switch (global.environmentQuality)
{
    case 1:
        global.texAlleywayFloor = sprite_get_texture(spr_alleyway_floor_64_64, 0);
        break;

    case 2:
        global.texAlleywayFloor = sprite_get_texture(spr_alleyway_floor_128_128, 0);
        break;

    case 3:
        global.texAlleywayFloor = sprite_get_texture(spr_alleyway_floor_256_256, 0);
        break;

    case 4:
        global.texAlleywayFloor = sprite_get_texture(spr_alleyway_floor_512_512, 0);
        break;

    case 5:
        global.texAlleywayFloor = sprite_get_texture(spr_alleyway_floor_1024_1024, 0);
        break;

}

switch (global.propsQuality)
{
    case 1:
        global.texBaseballBat = sprite_get_texture(uv_baseball_bat_64_64_ninkyo, 0);
        global.texBinAshtray = sprite_get_texture(uv_bin_ashtray_buruwasu_64_64, 0);
        global.texBurningBarrel = sprite_get_texture(uv_wall_mounted_oil_lamp_64_64, 0);
        global.texChainLinkFence = sprite_get_texture(uv_chain_link_fence_64, 0);
        global.texDiningBooth00 = sprite_get_texture(uv_dining_booth00_64, 0);
        global.texDiningBooth01 = sprite_get_texture(uv_dining_booth01_64, 0);
        global.texDiningBooth02 = sprite_get_texture(uv_dining_booth02_64, 0);
        global.texDropBagOfMoney = sprite_get_texture(uv_drop_bag_of_money_64, 0);
        global.texDumpster = sprite_get_texture(uv_dumpster_model_buruwasu_64, 0);
        global.texElectricalBox = sprite_get_texture(uv_electrical_box_with_stop_wires_64, 0);
        global.texEuroPallet = sprite_get_texture(uv_euro_pallet_64, 0);
        global.texModernBench = sprite_get_texture(uv_modern_bench_64_64, 0);
        global.texOilLamp = sprite_get_texture(uv_wall_mounted_oil_lamp_64_64, 0);
        global.texPrayerShrineShrine = sprite_get_texture(uv_prayer_shrine_shrine_64, 0);
        global.texPrayerShrineStand = sprite_get_texture(uv_prayer_shrine_stand_64, 0);
        global.texRubbishSkip = sprite_get_texture(uv_skip_texture_64, 0);
        global.texStreetLampPost = sprite_get_texture(uv_street_lamp_post_64_64, 0);
        break;

    case 2:
        global.texBaseballBat = sprite_get_texture(uv_baseball_bat_128_128_ninkyo, 0);
        global.texBinAshtray = sprite_get_texture(uv_bin_ashtray_buruwasu_128_128, 0);
        global.texBurningBarrel = sprite_get_texture(uv_wall_mounted_oil_lamp_128_128, 0);
        global.texChainLinkFence = sprite_get_texture(uv_chain_link_fence_128, 0);
        global.texDiningBooth00 = sprite_get_texture(uv_dining_booth00_128, 0);
        global.texDiningBooth01 = sprite_get_texture(uv_dining_booth01_128, 0);
        global.texDiningBooth02 = sprite_get_texture(uv_dining_booth02_128, 0);
        global.texDropBagOfMoney = sprite_get_texture(uv_drop_bag_of_money_128, 0);
        global.texDumpster = sprite_get_texture(uv_dumpster_model_buruwasu_128, 0);
        global.texElectricalBox = sprite_get_texture(uv_electrical_box_with_stop_wires_128, 0);
        global.texEuroPallet = sprite_get_texture(uv_euro_pallet_128, 0);
        global.texModernBench = sprite_get_texture(uv_modern_bench_128_128, 0);
        global.texOilLamp = sprite_get_texture(uv_wall_mounted_oil_lamp_128_128, 0);
        global.texPrayerShrineShrine = sprite_get_texture(uv_prayer_shrine_shrine_128, 0);
        global.texPrayerShrineStand = sprite_get_texture(uv_prayer_shrine_stand_128, 0);
        global.texRubbishSkip = sprite_get_texture(uv_skip_texture_128, 0);
        global.texStreetLampPost = sprite_get_texture(uv_street_lamp_post_128_128, 0);
        break;

    case 3:
        global.texBaseballBat = sprite_get_texture(uv_baseball_bat_256_256_ninkyo, 0);
        global.texBinAshtray = sprite_get_texture(uv_bin_ashtray_buruwasu_256_256, 0);
        global.texBurningBarrel = sprite_get_texture(uv_burning_barrel_512, 0);
        global.texChainLinkFence = sprite_get_texture(uv_chain_link_fence_256, 0);
        global.texDiningBooth00 = sprite_get_texture(uv_dining_booth00_256, 0);
        global.texDiningBooth01 = sprite_get_texture(uv_dining_booth01_256, 0);
        global.texDiningBooth02 = sprite_get_texture(uv_dining_booth02_256, 0);
        global.texDropBagOfMoney = sprite_get_texture(uv_drop_bag_of_money_256, 0);
        global.texDumpster = sprite_get_texture(uv_dumpster_model_buruwasu_256, 0);
        global.texElectricalBox = sprite_get_texture(uv_electrical_box_with_stop_wires_256, 0);
        global.texEuroPallet = sprite_get_texture(uv_euro_pallet_256, 0);
        global.texModernBench = sprite_get_texture(uv_modern_bench_256_256, 0);
        global.texOilLamp = sprite_get_texture(uv_wall_mounted_oil_lamp_256_256, 0);
        global.texPrayerShrineShrine = sprite_get_texture(uv_prayer_shrine_shrine_256, 0);
        global.texPrayerShrineStand = sprite_get_texture(uv_prayer_shrine_stand_256, 0);
        global.texRubbishSkip = sprite_get_texture(uv_skip_texture_256, 0);
        global.texStreetLampPost = sprite_get_texture(uv_street_lamp_post_256_256, 0);
        break;

    case 4:
        global.texBaseballBat = sprite_get_texture(uv_baseball_bat_512_512_ninkyo, 0);
        global.texBinAshtray = sprite_get_texture(uv_bin_ashtray_buruwasu_512_512, 0);
        global.texBurningBarrel = sprite_get_texture(uv_wall_mounted_oil_lamp_512_512, 0);
        global.texChainLinkFence = sprite_get_texture(uv_chain_link_fence_512, 0);
        global.texDiningBooth00 = sprite_get_texture(uv_dining_booth00_512, 0);
        global.texDiningBooth01 = sprite_get_texture(uv_dining_booth01_512, 0);
        global.texDiningBooth02 = sprite_get_texture(uv_dining_booth02_512, 0);
        global.texDropBagOfMoney = sprite_get_texture(uv_drop_bag_of_money_512, 0);
        global.texDumpster = sprite_get_texture(uv_dumpster_model_buruwasu_512, 0);
        global.texElectricalBox = sprite_get_texture(uv_electrical_box_with_stop_wires_512, 0);
        global.texEuroPallet = sprite_get_texture(uv_euro_pallet_512, 0);
        global.texModernBench = sprite_get_texture(uv_modern_bench_512_512, 0);
        global.texOilLamp = sprite_get_texture(uv_wall_mounted_oil_lamp_512_512, 0);
        global.texPrayerShrineShrine = sprite_get_texture(uv_prayer_shrine_shrine_512, 0);
        global.texPrayerShrineStand = sprite_get_texture(uv_prayer_shrine_stand_512, 0);
        global.texRubbishSkip = sprite_get_texture(uv_skip_texture_512, 0);
        global.texStreetLampPost = sprite_get_texture(uv_street_lamp_post_512_512, 0);
        break;

    case 5:
        global.texBaseballBat = sprite_get_texture(uv_baseball_bat_1024_1024_ninkyo, 0);
        global.texBinAshtray = sprite_get_texture(uv_bin_ashtray_buruwasu_1024_1024, 0);
        global.texBurningBarrel = sprite_get_texture(uv_wall_mounted_oil_lamp_1024_1024, 0);
        global.texChainLinkFence = sprite_get_texture(uv_chain_link_fence_1024, 0);
        global.texDiningBooth00 = sprite_get_texture(uv_dining_booth00_1024, 0);
        global.texDiningBooth01 = sprite_get_texture(uv_dining_booth01_1024, 0);
        global.texDiningBooth02 = sprite_get_texture(uv_dining_booth02_1024, 0);
        global.texDropBagOfMoney = sprite_get_texture(uv_drop_bag_of_money_1024, 0);
        global.texDumpster = sprite_get_texture(uv_dumpster_model_buruwasu_1024, 0);
        global.texElectricalBox = sprite_get_texture(uv_electrical_box_with_stop_wires_1024, 0);
        global.texEuroPallet = sprite_get_texture(uv_euro_pallet_1024, 0);
        global.texModernBench = sprite_get_texture(uv_modern_bench_1024_1024, 0);
        global.texOilLamp = sprite_get_texture(uv_wall_mounted_oil_lamp_1024_1024, 0);
        global.texPrayerShrineShrine = sprite_get_texture(uv_prayer_shrine_shrine_1024, 0);
        global.texPrayerShrineStand = sprite_get_texture(uv_prayer_shrine_stand_1024, 0);
        global.texRubbishSkip = sprite_get_texture(uv_skip_texture_1024, 0);
        global.texStreetLampPost = sprite_get_texture(uv_street_lamp_post_1024_1024, 0);
        break;

}

switch (global.treeQuality)
{
    case 1:
        global.texOakTree = sprite_get_texture(uv_oak_tree_64_64, 0);
        break;

    case 2:
        global.texOakTree = sprite_get_texture(uv_oak_tree_128_128, 0);
        break;

    case 3:
        global.texOakTree = sprite_get_texture(uv_oak_tree_256_256, 0);
        break;

    case 4:
        global.texOakTree = sprite_get_texture(uv_oak_tree_512_512, 0);
        break;

    case 5:
        global.texOakTree = sprite_get_texture(uv_oak_tree_1024_1024, 0);
        break;

}
