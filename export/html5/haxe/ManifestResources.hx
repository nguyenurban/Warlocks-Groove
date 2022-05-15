package;


import haxe.io.Bytes;
import lime.utils.AssetBundle;
import lime.utils.AssetLibrary;
import lime.utils.AssetManifest;
import lime.utils.Assets;

#if sys
import sys.FileSystem;
#end

@:access(lime.utils.Assets)


@:keep @:dox(hide) class ManifestResources {


	public static var preloadLibraries:Array<AssetLibrary>;
	public static var preloadLibraryNames:Array<String>;
	public static var rootPath:String;


	public static function init (config:Dynamic):Void {

		preloadLibraries = new Array ();
		preloadLibraryNames = new Array ();

		rootPath = null;

		if (config != null && Reflect.hasField (config, "rootPath")) {

			rootPath = Reflect.field (config, "rootPath");

		}

		if (rootPath == null) {

			#if (ios || tvos || emscripten)
			rootPath = "assets/";
			#elseif android
			rootPath = "";
			#elseif console
			rootPath = lime.system.System.applicationDirectory;
			#else
			rootPath = "./";
			#end

		}

		#if (openfl && !flash && !display)
		openfl.text.Font.registerFont (__ASSET__OPENFL__assets_font_ttf);
		openfl.text.Font.registerFont (__ASSET__OPENFL__flixel_fonts_nokiafc22_ttf);
		openfl.text.Font.registerFont (__ASSET__OPENFL__flixel_fonts_monsterrat_ttf);
		
		#end

		var data, manifest, library, bundle;

		#if kha

		null
		library = AssetLibrary.fromManifest (manifest);
		Assets.registerLibrary ("null", library);

		if (library != null) preloadLibraries.push (library);
		else preloadLibraryNames.push ("null");

		#else

		data = '{"name":null,"assets":"aoy4:pathy30:assets%2Fcredits%2Fcredits.txty4:sizei105y4:typey4:TEXTy2:idR1y7:preloadtgoR0y25:assets%2Fdata%2Flvl1.jsonR2i47799R3R4R5R7R6tgoR0y25:assets%2Fdata%2Fmap1.ogmoR2i54916R3R4R5R8R6tgoR0y23:assets%2Fdata%2Fr1.jsonR2i1706970R3R4R5R9R6tgoR0y26:assets%2Fdata%2Froom1.jsonR2i15512R3R4R5R10R6tgoR0y26:assets%2Fdata%2Froom2.jsonR2i15523R3R4R5R11R6tgoR0y26:assets%2Fdata%2Froom3.jsonR2i25334R3R4R5R12R6tgoR0y26:assets%2Fdata%2Froom4.jsonR2i15718R3R4R5R13R6tgoR0y26:assets%2Fdata%2Froom5.jsonR2i15728R3R4R5R14R6tgoR0y26:assets%2Fdata%2Froom6.jsonR2i20160R3R4R5R15R6tgoR0y26:assets%2Fdata%2Froom7.jsonR2i15941R3R4R5R16R6tgoR0y26:assets%2Fdata%2Froom8.jsonR2i21789R3R4R5R17R6tgoR0y25:assets%2Fdata%2Ftiles.pngR2i35688R3y5:IMAGER5R18R6tgoR2i28952R3y4:FONTy9:classNamey24:__ASSET__assets_font_ttfR5y17:assets%2Ffont.ttfR6tgoR0y38:assets%2Fimages%2FBat_Sprite_Sheet.pngR2i2628R3R19R5R24R6tgoR0y45:assets%2Fimages%2FCharacters_Sprite_Sheet.pngR2i46262R3R19R5R25R6tgoR0y26:assets%2Fimages%2FDoor.pngR2i648R3R19R5R26R6tgoR0y28:assets%2Fimages%2Fenergy.pngR2i235R3R19R5R27R6tgoR0y28:assets%2Fimages%2Fhealth.pngR2i625R3R19R5R28R6tgoR0y36:assets%2Fimages%2Fimages-go-here.txtR2zR3R4R5R29R6tgoR0y43:assets%2Fimages%2Fjudge_sprites%2Fgreat.pngR2i1361R3R19R5R30R6tgoR0y45:assets%2Fimages%2Fjudge_sprites%2Fmisfire.pngR2i1296R3R19R5R31R6tgoR0y40:assets%2Fimages%2Fjudge_sprites%2Fok.pngR2i833R3R19R5R32R6tgoR0y41:assets%2Fimages%2Fjudge_sprites%2Fooe.pngR2i1685R3R19R5R33R6tgoR0y45:assets%2Fimages%2Fjudge_sprites%2Fperfect.pngR2i1300R3R19R5R34R6tgoR0y35:assets%2Fimages%2Fmagic_missile.pngR2i12870R3R19R5R35R6tgoR0y31:assets%2Fimages%2Fmetronome.pngR2i30800R3R19R5R36R6tgoR0y27:assets%2Fimages%2Fmouse.pngR2i5211R3R19R5R37R6tgoR0y45:assets%2Fimages%2FNotOctorok_Sprite_Sheet.pngR2i1601R3R19R5R38R6tgoR0y28:assets%2Fimages%2Fplayer.pngR2i1886R3R19R5R39R6tgoR0y29:assets%2Fimages%2Fshooter.pngR2i47783R3R19R5R40R6tgoR0y35:assets%2Fimages%2Fticks%2Fgreen.pngR2i228R3R19R5R41R6tgoR0y37:assets%2Fimages%2Fticks%2Fgreen_g.pngR2i225R3R19R5R42R6tgoR0y37:assets%2Fimages%2Fticks%2Fgreen_o.pngR2i212R3R19R5R43R6tgoR0y37:assets%2Fimages%2Fticks%2Fgreen_p.pngR2i223R3R19R5R44R6tgoR0y36:assets%2Fimages%2Fticks%2Fpurple.pngR2i212R3R19R5R45R6tgoR0y38:assets%2Fimages%2Fticks%2Fpurple_g.pngR2i224R3R19R5R46R6tgoR0y38:assets%2Fimages%2Fticks%2Fpurple_o.pngR2i222R3R19R5R47R6tgoR0y38:assets%2Fimages%2Fticks%2Fpurple_p.pngR2i221R3R19R5R48R6tgoR0y33:assets%2Fimages%2Fticks%2Fred.pngR2i230R3R19R5R49R6tgoR0y35:assets%2Fimages%2Fticks%2Fred_g.pngR2i225R3R19R5R50R6tgoR0y35:assets%2Fimages%2Fticks%2Fred_o.pngR2i242R3R19R5R51R6tgoR0y35:assets%2Fimages%2Fticks%2Fred_p.pngR2i223R3R19R5R52R6tgoR0y26:assets%2Fimages%2FWASD.pngR2i2719R3R19R5R53R6tgoR0y36:assets%2Fmusic%2Fmusic-goes-here.txtR2zR3R4R5R54R6tgoR2i2364674R3y5:MUSICR5y25:assets%2Fmusic%2Fstg1.mp3y9:pathGroupaR56hR6tgoR2i10188R3y5:SOUNDR5y26:assets%2Fsounds%2Fbeat.wavR57aR59hR6tgoR0y36:assets%2Fsounds%2Fsounds-go-here.txtR2zR3R4R5R60R6tgoR2i2114R3R55R5y26:flixel%2Fsounds%2Fbeep.mp3R57aR61y26:flixel%2Fsounds%2Fbeep.ogghR6tgoR2i39706R3R55R5y28:flixel%2Fsounds%2Fflixel.mp3R57aR63y28:flixel%2Fsounds%2Fflixel.ogghR6tgoR2i5794R3R58R5R62R57aR61R62hgoR2i33629R3R58R5R64R57aR63R64hgoR2i15744R3R20R21y35:__ASSET__flixel_fonts_nokiafc22_ttfR5y30:flixel%2Ffonts%2Fnokiafc22.ttfR6tgoR2i29724R3R20R21y36:__ASSET__flixel_fonts_monsterrat_ttfR5y31:flixel%2Ffonts%2Fmonsterrat.ttfR6tgoR0y33:flixel%2Fimages%2Fui%2Fbutton.pngR2i519R3R19R5R69R6tgoR0y36:flixel%2Fimages%2Flogo%2Fdefault.pngR2i3280R3R19R5R70R6tgh","rootPath":null,"version":2,"libraryArgs":[],"libraryType":null}';
		manifest = AssetManifest.parse (data, rootPath);
		library = AssetLibrary.fromManifest (manifest);
		Assets.registerLibrary ("default", library);
		

		library = Assets.getLibrary ("default");
		if (library != null) preloadLibraries.push (library);
		else preloadLibraryNames.push ("default");
		

		#end

	}


}


#if kha

null

#else

#if !display
#if flash

@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_credits_credits_txt extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_lvl1_json extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_map1_ogmo extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_r1_json extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_room1_json extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_room2_json extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_room3_json extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_room4_json extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_room5_json extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_room6_json extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_room7_json extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_room8_json extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_tiles_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_font_ttf extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_bat_sprite_sheet_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_characters_sprite_sheet_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_door_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_energy_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_health_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_images_go_here_txt extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_judge_sprites_great_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_judge_sprites_misfire_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_judge_sprites_ok_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_judge_sprites_ooe_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_judge_sprites_perfect_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_magic_missile_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_metronome_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_mouse_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_notoctorok_sprite_sheet_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_player_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_shooter_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_ticks_green_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_ticks_green_g_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_ticks_green_o_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_ticks_green_p_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_ticks_purple_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_ticks_purple_g_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_ticks_purple_o_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_ticks_purple_p_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_ticks_red_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_ticks_red_g_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_ticks_red_o_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_ticks_red_p_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_wasd_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_music_music_goes_here_txt extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_music_stg1_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sounds_beat_wav extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sounds_sounds_go_here_txt extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_sounds_beep_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_sounds_flixel_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_sounds_beep_ogg extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_sounds_flixel_ogg extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_fonts_nokiafc22_ttf extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_fonts_monsterrat_ttf extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_images_ui_button_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_images_logo_default_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__manifest_default_json extends null { }


#elseif (desktop || cpp)

@:keep @:file("assets/credits/credits.txt") @:noCompletion #if display private #end class __ASSET__assets_credits_credits_txt extends haxe.io.Bytes {}
@:keep @:file("assets/data/lvl1.json") @:noCompletion #if display private #end class __ASSET__assets_data_lvl1_json extends haxe.io.Bytes {}
@:keep @:file("assets/data/map1.ogmo") @:noCompletion #if display private #end class __ASSET__assets_data_map1_ogmo extends haxe.io.Bytes {}
@:keep @:file("assets/data/r1.json") @:noCompletion #if display private #end class __ASSET__assets_data_r1_json extends haxe.io.Bytes {}
@:keep @:file("assets/data/room1.json") @:noCompletion #if display private #end class __ASSET__assets_data_room1_json extends haxe.io.Bytes {}
@:keep @:file("assets/data/room2.json") @:noCompletion #if display private #end class __ASSET__assets_data_room2_json extends haxe.io.Bytes {}
@:keep @:file("assets/data/room3.json") @:noCompletion #if display private #end class __ASSET__assets_data_room3_json extends haxe.io.Bytes {}
@:keep @:file("assets/data/room4.json") @:noCompletion #if display private #end class __ASSET__assets_data_room4_json extends haxe.io.Bytes {}
@:keep @:file("assets/data/room5.json") @:noCompletion #if display private #end class __ASSET__assets_data_room5_json extends haxe.io.Bytes {}
@:keep @:file("assets/data/room6.json") @:noCompletion #if display private #end class __ASSET__assets_data_room6_json extends haxe.io.Bytes {}
@:keep @:file("assets/data/room7.json") @:noCompletion #if display private #end class __ASSET__assets_data_room7_json extends haxe.io.Bytes {}
@:keep @:file("assets/data/room8.json") @:noCompletion #if display private #end class __ASSET__assets_data_room8_json extends haxe.io.Bytes {}
@:keep @:image("assets/data/tiles.png") @:noCompletion #if display private #end class __ASSET__assets_data_tiles_png extends lime.graphics.Image {}
@:keep @:font("export/html5/obj/webfont/font.ttf") @:noCompletion #if display private #end class __ASSET__assets_font_ttf extends lime.text.Font {}
@:keep @:image("assets/images/Bat_Sprite_Sheet.png") @:noCompletion #if display private #end class __ASSET__assets_images_bat_sprite_sheet_png extends lime.graphics.Image {}
@:keep @:image("assets/images/Characters_Sprite_Sheet.png") @:noCompletion #if display private #end class __ASSET__assets_images_characters_sprite_sheet_png extends lime.graphics.Image {}
@:keep @:image("assets/images/Door.png") @:noCompletion #if display private #end class __ASSET__assets_images_door_png extends lime.graphics.Image {}
@:keep @:image("assets/images/energy.png") @:noCompletion #if display private #end class __ASSET__assets_images_energy_png extends lime.graphics.Image {}
@:keep @:image("assets/images/health.png") @:noCompletion #if display private #end class __ASSET__assets_images_health_png extends lime.graphics.Image {}
@:keep @:file("assets/images/images-go-here.txt") @:noCompletion #if display private #end class __ASSET__assets_images_images_go_here_txt extends haxe.io.Bytes {}
@:keep @:image("assets/images/judge_sprites/great.png") @:noCompletion #if display private #end class __ASSET__assets_images_judge_sprites_great_png extends lime.graphics.Image {}
@:keep @:image("assets/images/judge_sprites/misfire.png") @:noCompletion #if display private #end class __ASSET__assets_images_judge_sprites_misfire_png extends lime.graphics.Image {}
@:keep @:image("assets/images/judge_sprites/ok.png") @:noCompletion #if display private #end class __ASSET__assets_images_judge_sprites_ok_png extends lime.graphics.Image {}
@:keep @:image("assets/images/judge_sprites/ooe.png") @:noCompletion #if display private #end class __ASSET__assets_images_judge_sprites_ooe_png extends lime.graphics.Image {}
@:keep @:image("assets/images/judge_sprites/perfect.png") @:noCompletion #if display private #end class __ASSET__assets_images_judge_sprites_perfect_png extends lime.graphics.Image {}
@:keep @:image("assets/images/magic_missile.png") @:noCompletion #if display private #end class __ASSET__assets_images_magic_missile_png extends lime.graphics.Image {}
@:keep @:image("assets/images/metronome.png") @:noCompletion #if display private #end class __ASSET__assets_images_metronome_png extends lime.graphics.Image {}
@:keep @:image("assets/images/mouse.png") @:noCompletion #if display private #end class __ASSET__assets_images_mouse_png extends lime.graphics.Image {}
@:keep @:image("assets/images/NotOctorok_Sprite_Sheet.png") @:noCompletion #if display private #end class __ASSET__assets_images_notoctorok_sprite_sheet_png extends lime.graphics.Image {}
@:keep @:image("assets/images/player.png") @:noCompletion #if display private #end class __ASSET__assets_images_player_png extends lime.graphics.Image {}
@:keep @:image("assets/images/shooter.png") @:noCompletion #if display private #end class __ASSET__assets_images_shooter_png extends lime.graphics.Image {}
@:keep @:image("assets/images/ticks/green.png") @:noCompletion #if display private #end class __ASSET__assets_images_ticks_green_png extends lime.graphics.Image {}
@:keep @:image("assets/images/ticks/green_g.png") @:noCompletion #if display private #end class __ASSET__assets_images_ticks_green_g_png extends lime.graphics.Image {}
@:keep @:image("assets/images/ticks/green_o.png") @:noCompletion #if display private #end class __ASSET__assets_images_ticks_green_o_png extends lime.graphics.Image {}
@:keep @:image("assets/images/ticks/green_p.png") @:noCompletion #if display private #end class __ASSET__assets_images_ticks_green_p_png extends lime.graphics.Image {}
@:keep @:image("assets/images/ticks/purple.png") @:noCompletion #if display private #end class __ASSET__assets_images_ticks_purple_png extends lime.graphics.Image {}
@:keep @:image("assets/images/ticks/purple_g.png") @:noCompletion #if display private #end class __ASSET__assets_images_ticks_purple_g_png extends lime.graphics.Image {}
@:keep @:image("assets/images/ticks/purple_o.png") @:noCompletion #if display private #end class __ASSET__assets_images_ticks_purple_o_png extends lime.graphics.Image {}
@:keep @:image("assets/images/ticks/purple_p.png") @:noCompletion #if display private #end class __ASSET__assets_images_ticks_purple_p_png extends lime.graphics.Image {}
@:keep @:image("assets/images/ticks/red.png") @:noCompletion #if display private #end class __ASSET__assets_images_ticks_red_png extends lime.graphics.Image {}
@:keep @:image("assets/images/ticks/red_g.png") @:noCompletion #if display private #end class __ASSET__assets_images_ticks_red_g_png extends lime.graphics.Image {}
@:keep @:image("assets/images/ticks/red_o.png") @:noCompletion #if display private #end class __ASSET__assets_images_ticks_red_o_png extends lime.graphics.Image {}
@:keep @:image("assets/images/ticks/red_p.png") @:noCompletion #if display private #end class __ASSET__assets_images_ticks_red_p_png extends lime.graphics.Image {}
@:keep @:image("assets/images/WASD.png") @:noCompletion #if display private #end class __ASSET__assets_images_wasd_png extends lime.graphics.Image {}
@:keep @:file("assets/music/music-goes-here.txt") @:noCompletion #if display private #end class __ASSET__assets_music_music_goes_here_txt extends haxe.io.Bytes {}
@:keep @:file("assets/music/stg1.mp3") @:noCompletion #if display private #end class __ASSET__assets_music_stg1_mp3 extends haxe.io.Bytes {}
@:keep @:file("assets/sounds/beat.wav") @:noCompletion #if display private #end class __ASSET__assets_sounds_beat_wav extends haxe.io.Bytes {}
@:keep @:file("assets/sounds/sounds-go-here.txt") @:noCompletion #if display private #end class __ASSET__assets_sounds_sounds_go_here_txt extends haxe.io.Bytes {}
@:keep @:file("C:/HaxeToolkit/haxe/lib/flixel/4,11,0/assets/sounds/beep.mp3") @:noCompletion #if display private #end class __ASSET__flixel_sounds_beep_mp3 extends haxe.io.Bytes {}
@:keep @:file("C:/HaxeToolkit/haxe/lib/flixel/4,11,0/assets/sounds/flixel.mp3") @:noCompletion #if display private #end class __ASSET__flixel_sounds_flixel_mp3 extends haxe.io.Bytes {}
@:keep @:file("C:/HaxeToolkit/haxe/lib/flixel/4,11,0/assets/sounds/beep.ogg") @:noCompletion #if display private #end class __ASSET__flixel_sounds_beep_ogg extends haxe.io.Bytes {}
@:keep @:file("C:/HaxeToolkit/haxe/lib/flixel/4,11,0/assets/sounds/flixel.ogg") @:noCompletion #if display private #end class __ASSET__flixel_sounds_flixel_ogg extends haxe.io.Bytes {}
@:keep @:font("export/html5/obj/webfont/nokiafc22.ttf") @:noCompletion #if display private #end class __ASSET__flixel_fonts_nokiafc22_ttf extends lime.text.Font {}
@:keep @:font("export/html5/obj/webfont/monsterrat.ttf") @:noCompletion #if display private #end class __ASSET__flixel_fonts_monsterrat_ttf extends lime.text.Font {}
@:keep @:image("C:/HaxeToolkit/haxe/lib/flixel/4,11,0/assets/images/ui/button.png") @:noCompletion #if display private #end class __ASSET__flixel_images_ui_button_png extends lime.graphics.Image {}
@:keep @:image("C:/HaxeToolkit/haxe/lib/flixel/4,11,0/assets/images/logo/default.png") @:noCompletion #if display private #end class __ASSET__flixel_images_logo_default_png extends lime.graphics.Image {}
@:keep @:file("") @:noCompletion #if display private #end class __ASSET__manifest_default_json extends haxe.io.Bytes {}



#else

@:keep @:expose('__ASSET__assets_font_ttf') @:noCompletion #if display private #end class __ASSET__assets_font_ttf extends lime.text.Font { public function new () { #if !html5 __fontPath = "assets/font"; #else ascender = 933; descender = -247; height = 1206; numGlyphs = 218; underlinePosition = -105; underlineThickness = 50; unitsPerEM = 1000; #end name = "Cirno"; super (); }}
@:keep @:expose('__ASSET__flixel_fonts_nokiafc22_ttf') @:noCompletion #if display private #end class __ASSET__flixel_fonts_nokiafc22_ttf extends lime.text.Font { public function new () { #if !html5 __fontPath = "flixel/fonts/nokiafc22"; #else ascender = 2048; descender = -512; height = 2816; numGlyphs = 172; underlinePosition = -640; underlineThickness = 256; unitsPerEM = 2048; #end name = "Nokia Cellphone FC Small"; super (); }}
@:keep @:expose('__ASSET__flixel_fonts_monsterrat_ttf') @:noCompletion #if display private #end class __ASSET__flixel_fonts_monsterrat_ttf extends lime.text.Font { public function new () { #if !html5 __fontPath = "flixel/fonts/monsterrat"; #else ascender = 968; descender = -251; height = 1219; numGlyphs = 263; underlinePosition = -150; underlineThickness = 50; unitsPerEM = 1000; #end name = "Monsterrat"; super (); }}


#end

#if (openfl && !flash)

#if html5
@:keep @:expose('__ASSET__OPENFL__assets_font_ttf') @:noCompletion #if display private #end class __ASSET__OPENFL__assets_font_ttf extends openfl.text.Font { public function new () { __fromLimeFont (new __ASSET__assets_font_ttf ()); super (); }}
@:keep @:expose('__ASSET__OPENFL__flixel_fonts_nokiafc22_ttf') @:noCompletion #if display private #end class __ASSET__OPENFL__flixel_fonts_nokiafc22_ttf extends openfl.text.Font { public function new () { __fromLimeFont (new __ASSET__flixel_fonts_nokiafc22_ttf ()); super (); }}
@:keep @:expose('__ASSET__OPENFL__flixel_fonts_monsterrat_ttf') @:noCompletion #if display private #end class __ASSET__OPENFL__flixel_fonts_monsterrat_ttf extends openfl.text.Font { public function new () { __fromLimeFont (new __ASSET__flixel_fonts_monsterrat_ttf ()); super (); }}

#else
@:keep @:expose('__ASSET__OPENFL__assets_font_ttf') @:noCompletion #if display private #end class __ASSET__OPENFL__assets_font_ttf extends openfl.text.Font { public function new () { __fromLimeFont (new __ASSET__assets_font_ttf ()); super (); }}
@:keep @:expose('__ASSET__OPENFL__flixel_fonts_nokiafc22_ttf') @:noCompletion #if display private #end class __ASSET__OPENFL__flixel_fonts_nokiafc22_ttf extends openfl.text.Font { public function new () { __fromLimeFont (new __ASSET__flixel_fonts_nokiafc22_ttf ()); super (); }}
@:keep @:expose('__ASSET__OPENFL__flixel_fonts_monsterrat_ttf') @:noCompletion #if display private #end class __ASSET__OPENFL__flixel_fonts_monsterrat_ttf extends openfl.text.Font { public function new () { __fromLimeFont (new __ASSET__flixel_fonts_monsterrat_ttf ()); super (); }}

#end

#end
#end

#end
