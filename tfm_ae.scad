//$fn = 100;   // for rendering
$fn = 20;   // for previewing
assembly=true;

preview_adjustment = 0.1;

// cards
card_w = 64;
card_h = 89;
card_clearance_w = 1.5;
// box
box_w = 191;
box_l = 240;
box_h = 72;

box_clearance_l = 1.5;
box_clearance_w = 2;

container_w = box_w - box_clearance_w;
container_l = box_l - box_clearance_l;
container_h = box_h;

// printer
layer_height = 0.2;
nozzle = 0.4;
walls_lanes = 3;
bottom_layers = 4;
walls = walls_lanes*nozzle;
bottom = bottom_layers*layer_height;

// card_box
card_box_secondary_l = 135 + walls * 2;
card_box_main_l = container_l - card_box_secondary_l;
card_box_crisis_l = 70;
card_box_w = card_h + card_clearance_w + 2*walls;

// player mini tray
player_s = 8;
player_w = player_s * 5;
player_l = player_s * 3;
player_h = 8;
player_height_clearance = 3;
player_cavetto_r = 1.5;

player_tray_l = 46;
player_tray_w = (container_w - card_box_w)/3;
player_tray_h = player_h + player_cavetto_r*2 + bottom + player_height_clearance;
player_trays_h = player_tray_h*2;

// ocean
ocean_hex = 33.5;
ocean_hex_r = ((ocean_hex/2)/cos(30));
ocean_hex_h = 18.3;
ocean_hex_clearance = 1.5;

// forest
forest_hex_5 = 24.75;
forest_hex_5_r = ((forest_hex_5/2)/cos(30));
forest_hex_1 = 19.70;
forest_hex_1_r = ((forest_hex_1/2)/cos(30));

// crisis tray
crisis_tray_l = container_l - card_box_crisis_l - player_tray_l;
crisis_tray_w = container_w - card_box_w;
crisis_tray_h = ocean_hex_h + ocean_hex_clearance + bottom;

// second layer

// phase tray
phase_cavetto_r = 1;
phase = 47.5 + 1.5;
phase_tray_l = phase + 2*walls + 2*phase_cavetto_r;
phase_tray_w = container_w - card_box_w;
phase_tray_h = ocean_hex_h + ocean_hex_clearance + bottom;

// discovery tray
milestone_token_x = 55;
milestone_token_y = 18;
milestone_token_d = 23;

discovery_tray_l = container_l - card_box_crisis_l - player_tray_l - phase_tray_l;
discovery_tray_w = container_w - card_box_w;
discovery_tray_h = milestone_token_d + ocean_hex_clearance + bottom; 

// second layer height
layer_2_height = max([discovery_tray_h, phase_tray_h]);

// symbols and markers tray
symbols_and_markers_tray_l = player_tray_l;
symbols_and_markers_tray_w = crisis_tray_w;
symbols_and_markers_tray_h = (crisis_tray_h + layer_2_height) - player_trays_h;

// resource trays
resource_tray_l = container_l - card_box_crisis_l;
resource_tray_w = container_w - card_box_w;
resource_tray_h = container_h - (crisis_tray_h + discovery_tray_h);
resource_cavetto_r = 10;


// helper modules
module cube_rounded(v, r=3, center=false){
    translate([r,r,0])
    minkowski(){
        cube([v[0]-(2*r), v[1]-(2*r), v[2]-r], center);
        cylinder(r,r,r);
    }
}

// Separator
card_box_hole_offset = 0;
card_box_hole_r = 30;
module separator(distance=0){   // TODO: Refactor this
    translate([walls + distance, walls, bottom]) difference(){
        cube([walls,card_box_w-2*walls,container_h]);
        translate([-preview_adjustment,card_box_w/2,container_h-card_box_hole_offset]) rotate([0,90,0]) cylinder(h=card_box_w+2*preview_adjustment,r=card_box_hole_r);
    }
}

module generic_card_box(length, separators=[]){
    corners = 2;
    hole_r = card_box_hole_r;
    hole_offset = card_box_hole_offset;

    union() {
        difference(){
            union(){
                cube_rounded([length,card_box_w,container_h], corners);
                // translate([0,card_box_w/2,container_h-hole_offset]) rotate([0,90,0]) cylinder(h=card_box_l,r=hole_r+12);
            }
            translate([-preview_adjustment,card_box_w/2,container_h-hole_offset]) rotate([0,90,0]) cylinder(h=length+2*preview_adjustment,r=hole_r);
            translate([walls, walls, bottom]) cube([length - 2*walls,card_box_w-2*walls,2*container_h]);
        }

        for (i = [0:len(separators)-1:1]){
            separator(separators[i]);
        }
    }
}

module card_box_main() {
    generic_card_box(card_box_main_l, [20,30]); // TODO Separator length are placeholders
}

module card_box_secondary() {
    generic_card_box(card_box_secondary_l);
}

module card_box_crisis() {
    generic_card_box(card_box_crisis_l);
}

// symbol tray
// symbol_d = 9.72;
// symbol_pattern_l_count = 3;
// symbol_pattern_w_count = 5;
// //symbol_tray_h = container_h - (resource_tray_height(resource_h_gold)+resource_tray_height(resource_h_silver)+resource_tray_height(resource_h_bronze,2));
// module symbol_tray(){
//     difference(){
//         cube_rounded([resource_l, resource_w, symbol_tray_h]);
//         translate([walls+resource_cavetto_r, walls+resource_cavetto_r, bottom+resource_cavetto_r]) minkowski(){
//             cube([resource_l-2*(walls+resource_cavetto_r), resource_w-2*(walls+resource_cavetto_r), symbol_tray_h]);
//             sphere(r=resource_cavetto_r);
//         }
//         translate([
//             (resource_l - symbol_d*symbol_pattern_l_count - symbol_d/2*(symbol_pattern_l_count-1))/2,
//             (resource_w - symbol_d*symbol_pattern_w_count - symbol_d/2*(symbol_pattern_w_count-1))/2,
//             bottom - layer_height
//         ]) symbol_tray_pattern(symbol_d);
//     }
// }
// module symbol_tray_pattern(d){
//     for (i=[0:symbol_pattern_l_count-1]){
//         for (j=[0:symbol_pattern_w_count-1]){
//             translate([d/2,d/2,0]) translate([i*(d+d/2), j*(d+d/2), 0]) cylinder(10,r=d/2);
//         }
//     }
// }

// // player tray
// player_cube = 8;
// player_colors = 6;
// player_tray_h = container_h;
// player_tray_w = box_w - box_clearance_w - card_box_w;
// player_tray_l = 40;
// player_offset = player_cube + 10;
// player_rim = walls;
// player_notch = 5;
// clear_cube = 10.2;
// module player_tray(){
//     difference(){
//         d = 2.6*player_cube;
//         cube_rounded([player_tray_l, player_tray_w, player_tray_h]);
//         offset_y = (player_tray_w-2*player_rim)/(player_colors/2 + 0.5);
//         for (i=[0:player_colors/2-1]){
//             translate([d/2,d/2,player_offset]) translate([player_rim, player_rim+i*(offset_y), 0]) union(){
//                 cylinder(player_tray_h-player_offset + preview_adjustment, r=d/2);
//                 sphere(r=d/2);
//                 translate([-d/2-player_notch-preview_adjustment,-player_notch/2,0]) cube([player_notch*2,player_notch,player_tray_h-player_offset + preview_adjustment]);
//             }
//         }
//         for (i=[0:player_colors/2-1]){
//             translate([d/2,d/2,player_offset]) translate([player_tray_l-player_rim-d, player_rim+(i+0.5)*(offset_y), 0]) union(){
//                 cylinder(player_tray_h-player_offset + preview_adjustment, r=d/2);
//                 sphere(r=d/2);
//                 translate([d/2-player_notch+preview_adjustment,-player_notch/2,0]) cube([player_notch*2,player_notch,player_tray_h-player_offset + preview_adjustment]);
//             }
//         }
//         // marker
//         d_clear = clear_cube * 1.2;
//         translate([player_rim+2, player_tray_w-player_rim-d_clear, player_tray_h-clear_cube*3]) minkowski(){
//             cube([d_clear-2, d_clear-2, clear_cube*3]);
//             sphere(r=2);
//         }
//     }
// }

// crisis trays
module crisis_tray(){
    vp_3 = 24.8;
    vp_1 = 14.7;
    crisis_d = 14.7;
    damage_w = 26.6;
    damage_l = 50;
    damage_t = 2;
    damage_clearance = 1.5;
    ocean_hex = 33.5;
    ocean_hex_r = ((ocean_hex/2)/cos(30));
    ocean_hex_h=18.3;
    ocean_hex_clearance = 1.5;
    crisis_vp_tray_l = (crisis_tray_l+walls)/2;
    vp_3_w= 55;
    vp_1_w= 33;
    finger = 25/2;

    difference(){
        cube_rounded([crisis_tray_l, crisis_tray_w, crisis_tray_h]);
        minko_vp_3_w = vp_3_w-2*(walls+resource_cavetto_r);
        minko_vp_3_l = crisis_vp_tray_l-2*(walls+resource_cavetto_r);
        // vp 3
        translate([crisis_tray_l-crisis_vp_tray_l+walls+resource_cavetto_r, walls+resource_cavetto_r, bottom+resource_cavetto_r]) union(){
            minkowski(){
                cube([minko_vp_3_l, minko_vp_3_w, crisis_tray_h]);
                sphere(r=resource_cavetto_r);
            }
            translate([vp_3/2 + (minko_vp_3_l - vp_3)/2,minko_vp_3_w/2,-resource_cavetto_r-layer_height]) crisis_vp_tray_pattern(vp_3,1);
        }
        // vp 1
        minko_vp_1_w = vp_1_w-2*(walls+resource_cavetto_r);
        minko_vp_1_l = crisis_vp_tray_l-2*(walls+resource_cavetto_r);
        translate([walls+resource_cavetto_r, resource_cavetto_r+walls, bottom+resource_cavetto_r]) union(){
            minkowski(){
                cube([minko_vp_1_l, minko_vp_1_w, crisis_tray_h]);
                sphere(r=resource_cavetto_r);
            }
            translate([vp_1/2 + (minko_vp_1_l - (2*vp_1 + 1*vp_1/6))/2,minko_vp_1_w/2,-resource_cavetto_r-layer_height]) crisis_vp_tray_pattern(vp_1,2);
        }
        // crisis marker
        minko_cm_1_w = minko_vp_1_w;
        minko_cm_1_l = minko_vp_1_l;
        translate([walls+resource_cavetto_r, minko_vp_1_w+3*resource_cavetto_r+2*walls, bottom+resource_cavetto_r]) union(){
            minkowski(){
                cube([minko_cm_1_l, minko_cm_1_w, crisis_tray_h]);
                sphere(r=resource_cavetto_r);
            }
            translate([vp_1/2 + (minko_cm_1_l - (2*vp_1 + 1*vp_1/6))/2,minko_cm_1_w/2,-resource_cavetto_r-layer_height]) crisis_cm_tray_pattern(vp_1,2);
        }
        // damage
        translate([(crisis_vp_tray_l-damage_l)/2-walls+damage_clearance, crisis_tray_w-damage_w-walls-damage_clearance, crisis_tray_h-(damage_t*3+damage_clearance)]) union(){
            minkowski(){
                cube([damage_l, damage_w, damage_t*3+damage_clearance]);
                sphere(r=damage_clearance);
            }
        }
        translate([crisis_vp_tray_l/2,crisis_tray_w,-preview_adjustment]) cylinder(crisis_tray_h+2*preview_adjustment,r=finger);
        // ocean hexes
        translate([crisis_tray_l-crisis_vp_tray_l+crisis_vp_tray_l/2,crisis_tray_w-walls-ocean_hex/2-ocean_hex_clearance,bottom+ocean_hex_clearance]) union(){
            minkowski(){
                cylinder(r=ocean_hex_r, h=20, $fn=6);
                sphere(r=ocean_hex_clearance);
            }
        }
        translate([crisis_tray_l-crisis_vp_tray_l+crisis_vp_tray_l/2,crisis_tray_w,-preview_adjustment]) cylinder(crisis_tray_h+2*preview_adjustment,r=finger);
    }
}
module crisis_vp_tray_pattern(d, count=1){
    for (i=[0:count-1]){
        translate([i*(d+d/6), 0, 0]) cylinder(10,r=d/2);
    }
}
module crisis_cm_tray_pattern(d, count=1){
    for (i=[0:count-1]){
        difference(){
            translate([i*(d+d/6), 0, 0]) cylinder(10,r=d/2);
            translate([i*(d+d/6), 0, 0]) rotate(90) cylinder(10,d/2,d/2,$fn=3);
        }
    }
}

// discovery tray

module forest_hex_5_block(h=10){
    cylinder(r=forest_hex_5_r, h=h, $fn=6);
}
module forest_hex_1_block(h=10){
    rotate([0,0,90]) cylinder(r=forest_hex_1_r, h=h, $fn=6);
}

module discovery_tray(){
    milestone_token_x = 55;
    milestone_token_y = 18;
    milestone_token_d = 23;

    discovery_clerance = 1.5;

    milestone_symbol_l = 55;
    milestone_symbol_w = 18;
    milestone_symbol_w_d = 23;
    award_symbol_l1 = 44;
    award_symbol_l1_5 = 35;
    award_symbol_l2 = 27;
    award_symbol_w1 = 8;
    award_symbol_w2 = 31.5;
    award_symbol_w3 = 34;
    award_symbol_w_d = milestone_symbol_w_d;
    discovery_cavetto_r = 5;
    discovery_ratio = 0.5;
    milestone_symbol_w_circle_offset = (milestone_symbol_w_d - milestone_symbol_w)/2;

    difference(){
        cube_rounded([discovery_tray_l, discovery_tray_w, layer_2_height]);
        minko_3_l = discovery_tray_l-2*(walls+discovery_cavetto_r);
        // award marker

        award_w = discovery_tray_w*(1-discovery_ratio)-2*walls-2*discovery_clerance;
        // translate([walls+discovery_cavetto_r, walls+discovery_cavetto_r, bottom+discovery_cavetto_r]) minkowski(){
        //     cube([discovery_tray_l-2*(walls+discovery_cavetto_r), award_w, layer_2_height]);
        //     sphere(r=discovery_cavetto_r);
        // }
        translate([walls + 24, discovery_tray_w + walls, 0]) union() {  // TODO Do not harcode that 24
            translate([-award_symbol_l2/2, - (award_symbol_w2 + walls*3 + discovery_clerance), bottom + discovery_clerance]) minkowski() {
                union() {
                    award_pattern(layer_2_height - bottom - discovery_clerance);
                    translate([award_symbol_l2/2 - award_symbol_w_d/2 + discovery_clerance, award_symbol_w2, 0]) cube([award_symbol_w_d - discovery_clerance*2, walls*3 + discovery_clerance, discovery_tray_h - bottom - discovery_clerance]);
                }
                sphere(r=discovery_clerance);
            }
            translate([0,0,-preview_adjustment]) cylinder(h = bottom + preview_adjustment * 2, r = award_symbol_w_d/2 - discovery_clerance);
        }
        
        // translate([discovery_tray_l / 2 - 10, -preview_adjustment , bottom])  cube([20, 10, layer_2_height - bottom + preview_adjustment]);
        // translate([discovery_tray_l / 2, 0 ,-preview_adjustment])  cylinder(h = bottom + preview_adjustment * 2, r = 10);
        
        // milestone marker

        milestone_w = discovery_tray_w*discovery_ratio-walls-2*discovery_cavetto_r;
        // translate([walls+discovery_cavetto_r, discovery_tray_w-milestone_w-walls-discovery_cavetto_r, bottom+discovery_cavetto_r]) minkowski(){
        //     cube([discovery_tray_l-2*(walls+discovery_cavetto_r), milestone_w, discovery_tray_h]);
        //     sphere(r=discovery_cavetto_r);
        // }

        milestone_tray_y_offset = walls + discovery_clerance - milestone_symbol_w_circle_offset + 1;
        translate([(discovery_tray_l-milestone_symbol_l)/2, milestone_tray_y_offset, bottom + discovery_clerance]) minkowski() {
            union() {
                milestone_pattern(layer_2_height - (bottom + discovery_clerance));
                translate([milestone_symbol_l/2 - milestone_symbol_w_d/2 + discovery_clerance, -walls - discovery_clerance, 0]) cube([milestone_symbol_w_d - discovery_clerance*2, walls + discovery_clerance, discovery_tray_h - bottom - discovery_clerance]); 
            }
            sphere(r=discovery_clerance);
        }
        translate([discovery_tray_l / 2, 0 ,-preview_adjustment])  cylinder(h = bottom + preview_adjustment * 2, r = milestone_symbol_w_d/2 - discovery_clerance);

        // symbol tray
        // symbol_w = 22;
        // symbol_offset = -6;
        // translate([walls + discovery_cavetto_r, discovery_tray_w/2 - symbol_w/2 + symbol_offset, bottom + discovery_cavetto_r]) minkowski(){
        //     cube([discovery_tray_l- 2*walls - discovery_cavetto_r * 2, symbol_w, layer_2_height - bottom - discovery_cavetto_r]);
        //     sphere(r=discovery_cavetto_r);
        // }

        // forest 1 tray
        forest_1_tray_y_offset = milestone_w + walls + milestone_tray_y_offset;
        forest_1_tray_l = 33.3 + 3; // Clearance
        center_tray_offset = (discovery_tray_l - (walls*2 + discovery_clerance)*2 - forest_1_tray_l)/2;
        translate([walls*2 + discovery_clerance, forest_1_tray_y_offset, bottom + forest_hex_1_r + discovery_clerance]) minkowski(){
            union() {
                    translate([center_tray_offset,0,0]) rotate([0,90,0])  forest_hex_1_block(forest_1_tray_l);
                    translate([0,-forest_hex_1_r]) cube([discovery_tray_l - (walls*2 + discovery_clerance)*2, forest_hex_1_r * 2, 20]);
                }
            sphere(r=discovery_clerance);
        }

        // forest 5 tray
        //translate([discovery_tray_l - (walls + forest_hex_5_r + discovery_clerance) + 3, discovery_tray_w - (walls + forest_hex_5_r + discovery_clerance + 12), bottom + discovery_clerance]) minkowski(){
        forest_hex_5_tray_y = forest_1_tray_y_offset + walls + discovery_clerance*2 + forest_hex_1_r*2 + 1; // TODO 1 is a random offset
        translate([discovery_tray_l - (walls + forest_hex_5_r + discovery_clerance) + 2, forest_hex_5_tray_y, bottom + discovery_clerance]) minkowski(){
            union() {
                forest_hex_5_block(layer_2_height - bottom);
                translate([0,-6]) cube([20, 12, layer_2_height - bottom - discovery_clerance]);
            }
            sphere(r=discovery_clerance);
        }
        translate([discovery_tray_l, forest_hex_5_tray_y, - preview_adjustment]) cylinder(r = 6, h=layer_2_height + preview_adjustment*2);
    }

    module award_pattern(h=30){
        union(){
            cube_rounded([award_symbol_l2,award_symbol_w2,h], 2);
            translate([(award_symbol_l2-award_symbol_l1)/2,award_symbol_w2-award_symbol_w1,0]) intersection(){
                translate([0,-10,0]) cube([award_symbol_l1,award_symbol_w1+10,h]);
                translate([0,-award_symbol_w1+7.5,0]) cube_rounded([award_symbol_l1,award_symbol_w1+10,h],3);
            }
            translate([(award_symbol_l1_5-award_symbol_l1)/2,award_symbol_w2-13,0]) cube_rounded([award_symbol_l1_5,13,h],3);
            translate([award_symbol_l2/2,award_symbol_w2+(award_symbol_w3-award_symbol_w2)-award_symbol_w_d/2,0]) cylinder(h=h, r=award_symbol_w_d/2);
        }
    }
    module milestone_pattern(h=30){
        translate([0,milestone_symbol_w_circle_offset,0]) union(){
            cube_rounded([milestone_symbol_l,milestone_symbol_w,h],1);
            translate([milestone_symbol_l/2,milestone_symbol_w/2,0]) cylinder(h=h,r=milestone_symbol_w_d/2);
        }
        
    }
}

// phase tray
module phase_tray(){
    finger = 25/2;
    tray_h = layer_2_height;
    difference(){
        cube_rounded([phase_tray_l, phase_tray_w, tray_h]); 
        minko_3_l = phase_tray_l-2*(walls+phase_cavetto_r);

        // phase marker
        translate([walls+phase_cavetto_r, walls+phase_cavetto_r, bottom+phase_cavetto_r]) union(){
            minkowski(){
                cube([minko_3_l, minko_3_l, tray_h]);
                sphere(r=phase_cavetto_r);
            }
        }
        translate([phase_tray_l/2,0,-preview_adjustment]) cylinder(tray_h+2*preview_adjustment,r=finger);
        // ocean hexes
        translate([phase_tray_l/2,phase_tray_w-walls-ocean_hex/2-ocean_hex_clearance,bottom+ocean_hex_clearance]) union(){
            minkowski(){
                cylinder(r=ocean_hex_r, h=22, $fn=6);
                sphere(r=ocean_hex_clearance);
            }
        }
        translate([phase_tray_l/2,phase_tray_w,-preview_adjustment]) cylinder(tray_h+2*preview_adjustment,r=finger);
    }
}

// // forest tray

// module forest_tray(){
//     forest_cavetto_r = 5;
//     forest_ratio = 0.5;
//     forest_tray_l = card_box_l-resource_l-player_tray_l;
//     forest_tray_w = box_w - box_clearance_w - card_box_w;
//     forest_tray_h = container_h - phase_tray_h - layer_2_height;

//     difference(){
//         cube_rounded([forest_tray_l, forest_tray_w, forest_tray_h]);
//         minko_3_l = forest_tray_l-2*(walls+forest_cavetto_r);
//         // forest 5 marker
//         forest_5_w = forest_tray_w*(1-forest_ratio)-walls-2*forest_cavetto_r;
//         translate([walls+forest_cavetto_r, walls+forest_cavetto_r, bottom+forest_cavetto_r]) minkowski(){
//             cube([forest_tray_l-2*(walls+forest_cavetto_r), forest_5_w, forest_tray_h]);
//             sphere(r=forest_cavetto_r);
//         }
//         forest_hex_5_l = 3*2.5*forest_hex_5_r - forest_hex_5_r/2;
//         translate([(forest_tray_l-forest_hex_5_l)/2 + forest_hex_5_r, (forest_5_w+walls+2*forest_cavetto_r)/2, bottom - layer_height]) forest_hex_5_pattern();
//         // forest 1 marker
//         forest_1_w = forest_tray_w*forest_ratio-2*walls-2*forest_cavetto_r;
//         translate([walls+forest_cavetto_r, forest_tray_w-forest_1_w-walls-forest_cavetto_r, bottom+forest_cavetto_r]) minkowski(){
//             cube([forest_tray_l-2*(walls+forest_cavetto_r), forest_1_w, forest_tray_h]);
//             sphere(r=forest_cavetto_r);
//         }
//         forest_hex_1_l = 3*2.5*forest_hex_1_r - forest_hex_1_r/2;
//         translate([(forest_tray_l-forest_hex_1_l)/2 + forest_hex_1_r, discovery_tray_w-(forest_1_w+walls+2*forest_cavetto_r)/2, bottom - layer_height]) forest_hex_1_pattern();
//     }
// }
module forest_hex_5_pattern(){
    for (i=[0:2]){
        translate([i*2.5*forest_hex_5_r, 0, 0]) cylinder(r=forest_hex_5_r, h=10, $fn=6);;
    }
}
module forest_hex_1_pattern(){
    for (i=[0:2]){
        translate([i*2.5*forest_hex_1_r, 0, 0]) cylinder(r=forest_hex_1_r, h=10, $fn=6);;
    }
}

module money_tray(){
    difference(){
        cube_rounded([forest_tray_l, forest_tray_w, forest_tray_h]);
    }
}

// player mini tray

module player_tray() {
    tray_h = player_tray_h;
    tray_l = player_tray_l;
    tray_w = player_tray_w;
    cavetto_r = player_cavetto_r;
    height_clearance = player_height_clearance;

    difference() {
        cube_rounded([tray_l, tray_w, tray_h]);
        translate([walls + cavetto_r, walls + cavetto_r, bottom + preview_adjustment]) minkowski() {
            cube([player_w, player_l, player_h + height_clearance + cavetto_r]);
            sphere(r=cavetto_r);
        }
    
    }
}

module player_trays() {
    for (i = [0:1]) {
      for (j = [0:2]) {
        translate([0, player_tray_w * j, (player_tray_h) * i]) player_tray();
      }
    }
}


module symbols_and_markers_tray() {
    tray_h = symbols_and_markers_tray_h;
    tray_l = symbols_and_markers_tray_l;
    tray_w = symbols_and_markers_tray_w;
    markers_clearance = 0.5;
    markers_clearance_h = 1;
    markers_l = 29.5 + markers_clearance;
    markers_w = 10.5 + markers_clearance;
    markers_h = 10.5 + markers_clearance_h;
    cavetto_r = 1.5;

    difference() {
        cube_rounded([tray_l, tray_w, tray_h]);

        // trackers
        translate([walls + cavetto_r, walls + cavetto_r, tray_h - markers_h]) minkowski() {
            union() {
                translate([0,0, markers_h/2 - markers_clearance_h]) cube([tray_l - walls*2 - cavetto_r*2, markers_w, markers_h/2 + markers_clearance_h]);
                translate([(tray_l - walls*2 - cavetto_r*2 - markers_l)/2,0,0]) cube([markers_l, markers_w, markers_h]);
            }
            sphere(r=cavetto_r);
        }
    
        // symbols
        translate([walls + cavetto_r, markers_w + walls*2 + cavetto_r*3, bottom + cavetto_r]) minkowski() {
            cube([tray_l - walls*2 - cavetto_r*2, tray_w - (walls*3 + markers_w + cavetto_r*4), tray_h - bottom]);
            sphere(r=cavetto_r);
        }
    }
}

// resource trays

module resource_tray(size_percentage){
    resource_clearance = 1;
    resource_h_bronze = 7.3;
    resource_h_silver = 8.2;
    resource_h_gold = 10.3;
    resource_pattern_l_count = 3;
    resource_pattern_w_count = 5;
    tray_l = size_percentage * resource_tray_l;

    difference(){
        cube_rounded([tray_l, resource_tray_w, resource_tray_h]);
        translate([walls+resource_cavetto_r, walls+resource_cavetto_r, bottom+resource_cavetto_r]) minkowski(){
            cube([tray_l-2*(walls+resource_cavetto_r), resource_tray_w-2*(walls+resource_cavetto_r), resource_tray_h]);
            sphere(r=resource_cavetto_r);
        }
        // translate([
        //     (tray_l - h*resource_pattern_l_count - h/2*(resource_pattern_l_count-1))/2,
        //     (resource_tray_w - h*resource_pattern_w_count - h/2*(resource_pattern_w_count-1))/2,
        //     bottom - layer_height
        // ]) resource_tray_pattern(h);
    }
}
module resource_tray_pattern(h){
    for (i=[0:resource_pattern_l_count-1]){
        for (j=[0:resource_pattern_w_count-1]){
            translate([i*(h+h/2), j*(h+h/2), 0]) cube_rounded([h,h,h],0.5);
        }
    }
}
module resource_tray_pattern_random(h){
    // scratched idea, didn't like the look
    for (i=[0:9]){
        random_y = rands(0,resource_tray_w-2*(walls+resource_cavetto_r),1);
        random_x = rands(0,resource_tray_l-2*(walls+resource_cavetto_r),1);
        translate([random_x[0], random_y[0], 0]) cube([h,h,h]);
    }
}

bronze_p = 0.5;
module resource_tray_bronze(){
    resource_tray(bronze_p);
}
silver_p = 0.2;
module resource_tray_silver(){
    resource_tray(silver_p);
}
gold_p = 0.3;
module resource_tray_gold(){
    resource_tray(gold_p);
}



// assembly
if(assembly){
    color("darkorange") card_box_main();
    color("orange") translate([card_box_main_l,0,0]) card_box_secondary();
    color("red") translate([container_l - card_box_crisis_l, card_box_w, 0]) card_box_crisis();
    
    color("turquoise") translate([crisis_tray_l,card_box_w,0]) player_trays();
    color("crimson") translate([0,card_box_w,0]) crisis_tray();
    color("khaki") translate([0,card_box_w,crisis_tray_h]) discovery_tray();
    color("midnightblue") translate([discovery_tray_l,card_box_w,crisis_tray_h]) phase_tray();
    //color("salmon") translate([card_box_l-resource_l-player_tray_l-phase_tray_l-discovery_tray_l,card_box_w,crisis_tray_h+discovery_tray_h]) money_tray();
    color("salmon") translate([crisis_tray_l,card_box_w,player_trays_h]) symbols_and_markers_tray();

    layer_3_offset = crisis_tray_h + layer_2_height;
    color("gold") translate([0,card_box_w,layer_3_offset]) resource_tray_gold();
    color("silver") translate([0 + (gold_p * resource_tray_l),card_box_w,layer_3_offset]) resource_tray_silver();
    color("peru") translate([0 + ((gold_p + silver_p) * resource_tray_l),card_box_w,layer_3_offset]) resource_tray_bronze();
    //color("plum") translate([card_box_l-resource_l,-card_box_w,resource_tray_height(resource_h_gold)+resource_tray_height(resource_h_silver)+resource_tray_height(resource_h_bronze,2)]) symbol_tray();
} else {
    
}