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
		openfl.text.Font.registerFont (__ASSET__OPENFL__assets_pressstart2p_ttf);
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

		data = '{"name":null,"assets":"aoy4:pathy30:assets%2Fcredits%2Fcredits.txty4:sizei964y4:typey4:TEXTy2:idR1y7:preloadtgoR0y42:assets%2Fcredits%2Fpressstart2plicense.txtR2i4500R3R4R5R7R6tgoR0y25:assets%2Fdata%2Flvl1.jsonR2i47728R3R4R5R8R6tgoR0y30:assets%2Fdata%2Flvl2room1.jsonR2i15673R3R4R5R9R6tgoR0y30:assets%2Fdata%2Flvl2room2.jsonR2i23184R3R4R5R10R6tgoR0y30:assets%2Fdata%2Flvl2room3.jsonR2i25468R3R4R5R11R6tgoR0y30:assets%2Fdata%2Flvl2room4.jsonR2i21467R3R4R5R12R6tgoR0y30:assets%2Fdata%2Flvl2room5.jsonR2i19267R3R4R5R13R6tgoR0y30:assets%2Fdata%2Flvl2room6.jsonR2i20036R3R4R5R14R6tgoR0y30:assets%2Fdata%2Flvl2room7.jsonR2i21109R3R4R5R15R6tgoR0y30:assets%2Fdata%2Flvl2room8.jsonR2i25079R3R4R5R16R6tgoR0y30:assets%2Fdata%2Flvl3room1.jsonR2i15567R3R4R5R17R6tgoR0y31:assets%2Fdata%2Flvl3room10.jsonR2i23185R3R4R5R18R6tgoR0y31:assets%2Fdata%2Flvl3room11.jsonR2i20804R3R4R5R19R6tgoR0y31:assets%2Fdata%2Flvl3room12.jsonR2i21929R3R4R5R20R6tgoR0y31:assets%2Fdata%2Flvl3room13.jsonR2i34325R3R4R5R21R6tgoR0y31:assets%2Fdata%2Flvl3room14.jsonR2i30215R3R4R5R22R6tgoR0y31:assets%2Fdata%2Flvl3room15.jsonR2i25039R3R4R5R23R6tgoR0y30:assets%2Fdata%2Flvl3room2.jsonR2i21744R3R4R5R24R6tgoR0y30:assets%2Fdata%2Flvl3room3.jsonR2i21237R3R4R5R25R6tgoR0y30:assets%2Fdata%2Flvl3room4.jsonR2i30411R3R4R5R26R6tgoR0y30:assets%2Fdata%2Flvl3room5.jsonR2i20803R3R4R5R27R6tgoR0y30:assets%2Fdata%2Flvl3room6.jsonR2i24086R3R4R5R28R6tgoR0y30:assets%2Fdata%2Flvl3room7.jsonR2i29483R3R4R5R29R6tgoR0y30:assets%2Fdata%2Flvl3room8.jsonR2i19088R3R4R5R30R6tgoR0y30:assets%2Fdata%2Flvl3room9.jsonR2i20891R3R4R5R31R6tgoR0y25:assets%2Fdata%2Fmap1.ogmoR2i59020R3R4R5R32R6tgoR0y23:assets%2Fdata%2Fr1.jsonR2i1575810R3R4R5R33R6tgoR0y26:assets%2Fdata%2Froom1.jsonR2i15439R3R4R5R34R6tgoR0y26:assets%2Fdata%2Froom2.jsonR2i15450R3R4R5R35R6tgoR0y26:assets%2Fdata%2Froom3.jsonR2i25258R3R4R5R36R6tgoR0y26:assets%2Fdata%2Froom4.jsonR2i15642R3R4R5R37R6tgoR0y26:assets%2Fdata%2Froom5.jsonR2i15652R3R4R5R38R6tgoR0y26:assets%2Fdata%2Froom6.jsonR2i20082R3R4R5R39R6tgoR0y26:assets%2Fdata%2Froom7.jsonR2i15863R3R4R5R40R6tgoR0y26:assets%2Fdata%2Froom8.jsonR2i21714R3R4R5R41R6tgoR0y25:assets%2Fdata%2Ftiles.pngR2i35688R3y5:IMAGER5R42R6tgoR2i28952R3y4:FONTy9:classNamey24:__ASSET__assets_font_ttfR5y17:assets%2Ffont.ttfR6tgoR0y44:assets%2Fimages%2FAlligator_Sprite_Sheet.pngR2i10636R3R43R5R48R6tgoR0y38:assets%2Fimages%2FBat_Sprite_Sheet.pngR2i2628R3R43R5R49R6tgoR0y42:assets%2Fimages%2Fbeat_light%20%28o%29.pngR2i7740R3R43R5R50R6tgoR0y32:assets%2Fimages%2Fbeat_light.pngR2i3635R3R43R5R51R6tgoR0y32:assets%2Fimages%2Fcat_shield.pngR2i511218R3R43R5R52R6tgoR0y38:assets%2Fimages%2FCat_Sprite_Sheet.pngR2i2343R3R43R5R53R6tgoR0y30:assets%2Fimages%2Fcat_wave.pngR2i287R3R43R5R54R6tgoR0y45:assets%2Fimages%2FCharacters_Sprite_Sheet.pngR2i46262R3R43R5R55R6tgoR0y28:assets%2Fimages%2Fcharge.pngR2i22534R3R43R5R56R6tgoR0y31:assets%2Fimages%2Fcrosshair.pngR2i208R3R43R5R57R6tgoR0y26:assets%2Fimages%2FDoor.pngR2i648R3R43R5R58R6tgoR0y34:assets%2Fimages%2Fenemy_bullet.pngR2i154R3R43R5R59R6tgoR0y28:assets%2Fimages%2Fenergy.pngR2i235R3R43R5R60R6tgoR0y41:assets%2Fimages%2FGoblin_Sprite_Sheet.pngR2i39977R3R43R5R61R6tgoR0y28:assets%2Fimages%2Fhealth.pngR2i625R3R43R5R62R6tgoR0y36:assets%2Fimages%2Fimages-go-here.txtR2zR3R4R5R63R6tgoR0y43:assets%2Fimages%2Fjudge_sprites%2Fgreat.pngR2i1361R3R43R5R64R6tgoR0y45:assets%2Fimages%2Fjudge_sprites%2Fmisfire.pngR2i1602R3R43R5R65R6tgoR0y40:assets%2Fimages%2Fjudge_sprites%2Fok.pngR2i833R3R43R5R66R6tgoR0y41:assets%2Fimages%2Fjudge_sprites%2Fooe.pngR2i1685R3R43R5R67R6tgoR0y45:assets%2Fimages%2Fjudge_sprites%2Fperfect.pngR2i1300R3R43R5R68R6tgoR0y34:assets%2Fimages%2Flarge_bullet.pngR2i213R3R43R5R69R6tgoR0y27:assets%2Fimages%2Flaser.pngR2i165R3R43R5R70R6tgoR0y35:assets%2Fimages%2Fmagic_missile.pngR2i12870R3R43R5R71R6tgoR0y31:assets%2Fimages%2Fmetronome.pngR2i30800R3R43R5R72R6tgoR0y27:assets%2Fimages%2Fmouse.pngR2i5211R3R43R5R73R6tgoR0y45:assets%2Fimages%2FNotOctorok_Sprite_Sheet.pngR2i1601R3R43R5R74R6tgoR0y28:assets%2Fimages%2Fplayer.pngR2i1886R3R43R5R75R6tgoR0y26:assets%2Fimages%2FRock.pngR2i3303R3R43R5R76R6tgoR0y29:assets%2Fimages%2Fshooter.pngR2i47783R3R43R5R77R6tgoR0y40:assets%2Fimages%2FSlime_Sprite_Sheet.pngR2i3349R3R43R5R78R6tgoR0y38:assets%2Fimages%2FStriderShockwave.pngR2i55581R3R43R5R79R6tgoR0y35:assets%2Fimages%2Fticks%2Fgreen.pngR2i228R3R43R5R80R6tgoR0y47:assets%2Fimages%2Fticks%2Fgreen_e%20%28o%29.pngR2i233R3R43R5R81R6tgoR0y48:assets%2Fimages%2Fticks%2Fgreen_e%20%28o2%29.pngR2i7510R3R43R5R82R6tgoR0y37:assets%2Fimages%2Fticks%2Fgreen_e.pngR2i4517R3R43R5R83R6tgoR0y37:assets%2Fimages%2Fticks%2Fgreen_g.pngR2i225R3R43R5R84R6tgoR0y37:assets%2Fimages%2Fticks%2Fgreen_o.pngR2i212R3R43R5R85R6tgoR0y37:assets%2Fimages%2Fticks%2Fgreen_p.pngR2i223R3R43R5R86R6tgoR0y39:assets%2Fimages%2Fticks%2Fgreen_p_e.pngR2i245R3R43R5R87R6tgoR0y36:assets%2Fimages%2Fticks%2Fpurple.pngR2i212R3R43R5R88R6tgoR0y48:assets%2Fimages%2Fticks%2Fpurple_e%20%28o%29.pngR2i233R3R43R5R89R6tgoR0y49:assets%2Fimages%2Fticks%2Fpurple_e%20%28o2%29.pngR2i7515R3R43R5R90R6tgoR0y38:assets%2Fimages%2Fticks%2Fpurple_e.pngR2i4338R3R43R5R91R6tgoR0y38:assets%2Fimages%2Fticks%2Fpurple_g.pngR2i224R3R43R5R92R6tgoR0y38:assets%2Fimages%2Fticks%2Fpurple_o.pngR2i222R3R43R5R93R6tgoR0y38:assets%2Fimages%2Fticks%2Fpurple_p.pngR2i221R3R43R5R94R6tgoR0y40:assets%2Fimages%2Fticks%2Fpurple_p_e.pngR2i231R3R43R5R95R6tgoR0y33:assets%2Fimages%2Fticks%2Fred.pngR2i230R3R43R5R96R6tgoR0y45:assets%2Fimages%2Fticks%2Fred_e%20%28o%29.pngR2i234R3R43R5R97R6tgoR0y46:assets%2Fimages%2Fticks%2Fred_e%20%28o2%29.pngR2i7515R3R43R5R98R6tgoR0y35:assets%2Fimages%2Fticks%2Fred_e.pngR2i4725R3R43R5R99R6tgoR0y35:assets%2Fimages%2Fticks%2Fred_g.pngR2i225R3R43R5R100R6tgoR0y35:assets%2Fimages%2Fticks%2Fred_o.pngR2i242R3R43R5R101R6tgoR0y35:assets%2Fimages%2Fticks%2Fred_p.pngR2i223R3R43R5R102R6tgoR0y37:assets%2Fimages%2Fticks%2Fred_p_e.pngR2i233R3R43R5R103R6tgoR0y26:assets%2Fimages%2FWASD.pngR2i2719R3R43R5R104R6tgoR0y47:assets%2Fimages%2FWaterStrider_Sprite_Sheet.pngR2i33166R3R43R5R105R6tgoR0y36:assets%2Fmusic%2Fmusic-goes-here.txtR2zR3R4R5R106R6tgoR2i10421314R3y5:SOUNDR5y25:assets%2Fmusic%2Fstg1.wavy9:pathGroupaR108hR6tgoR2i82480R3R44R45y32:__ASSET__assets_pressstart2p_ttfR5y25:assets%2FPRESSSTART2P.TTFR6tgoR2i10188R3R107R5y26:assets%2Fsounds%2Fbeat.wavR109aR112hR6tgoR2i3336R3y5:MUSICR5y26:assets%2Fsounds%2Ffire.mp3R109aR114hR6tgoR2i5856R3R113R5y28:assets%2Fsounds%2Ffire_e.mp3R109aR115hR6tgoR2i6720R3R113R5y25:assets%2Fsounds%2Fhit.mp3R109aR116hR6tgoR2i8064R3R113R5y26:assets%2Fsounds%2Fkill.mp3R109aR117hR6tgoR0y36:assets%2Fsounds%2Fsounds-go-here.txtR2zR3R4R5R118R6tgoR0y43:assets%2Funused%2FM484BulletCollection1.pngR2i22490R3R43R5R119R6tgoR2i2114R3R113R5y26:flixel%2Fsounds%2Fbeep.mp3R109aR120y26:flixel%2Fsounds%2Fbeep.ogghR6tgoR2i39706R3R113R5y28:flixel%2Fsounds%2Fflixel.mp3R109aR122y28:flixel%2Fsounds%2Fflixel.ogghR6tgoR2i5794R3R107R5R121R109aR120R121hgoR2i33629R3R107R5R123R109aR122R123hgoR2i15744R3R44R45y35:__ASSET__flixel_fonts_nokiafc22_ttfR5y30:flixel%2Ffonts%2Fnokiafc22.ttfR6tgoR2i29724R3R44R45y36:__ASSET__flixel_fonts_monsterrat_ttfR5y31:flixel%2Ffonts%2Fmonsterrat.ttfR6tgoR0y33:flixel%2Fimages%2Fui%2Fbutton.pngR2i519R3R43R5R128R6tgoR0y36:flixel%2Fimages%2Flogo%2Fdefault.pngR2i3280R3R43R5R129R6tgh","rootPath":null,"version":2,"libraryArgs":[],"libraryType":null}';
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
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_credits_pressstart2plicense_txt extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_lvl1_json extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_lvl2room1_json extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_lvl2room2_json extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_lvl2room3_json extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_lvl2room4_json extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_lvl2room5_json extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_lvl2room6_json extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_lvl2room7_json extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_lvl2room8_json extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_lvl3room1_json extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_lvl3room10_json extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_lvl3room11_json extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_lvl3room12_json extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_lvl3room13_json extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_lvl3room14_json extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_lvl3room15_json extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_lvl3room2_json extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_lvl3room3_json extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_lvl3room4_json extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_lvl3room5_json extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_lvl3room6_json extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_lvl3room7_json extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_lvl3room8_json extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_lvl3room9_json extends null { }
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
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_alligator_sprite_sheet_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_bat_sprite_sheet_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_beat_light__o__png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_beat_light_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_cat_shield_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_cat_sprite_sheet_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_cat_wave_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_characters_sprite_sheet_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_charge_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_crosshair_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_door_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_enemy_bullet_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_energy_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_goblin_sprite_sheet_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_health_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_images_go_here_txt extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_judge_sprites_great_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_judge_sprites_misfire_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_judge_sprites_ok_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_judge_sprites_ooe_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_judge_sprites_perfect_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_large_bullet_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_laser_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_magic_missile_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_metronome_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_mouse_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_notoctorok_sprite_sheet_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_player_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_rock_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_shooter_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_slime_sprite_sheet_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_stridershockwave_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_ticks_green_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_ticks_green_e__o__png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_ticks_green_e__o2__png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_ticks_green_e_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_ticks_green_g_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_ticks_green_o_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_ticks_green_p_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_ticks_green_p_e_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_ticks_purple_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_ticks_purple_e__o__png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_ticks_purple_e__o2__png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_ticks_purple_e_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_ticks_purple_g_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_ticks_purple_o_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_ticks_purple_p_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_ticks_purple_p_e_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_ticks_red_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_ticks_red_e__o__png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_ticks_red_e__o2__png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_ticks_red_e_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_ticks_red_g_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_ticks_red_o_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_ticks_red_p_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_ticks_red_p_e_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_wasd_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_waterstrider_sprite_sheet_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_music_music_goes_here_txt extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_music_stg1_wav extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_pressstart2p_ttf extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sounds_beat_wav extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sounds_fire_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sounds_fire_e_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sounds_hit_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sounds_kill_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sounds_sounds_go_here_txt extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_unused_m484bulletcollection1_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
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
@:keep @:file("assets/credits/pressstart2plicense.txt") @:noCompletion #if display private #end class __ASSET__assets_credits_pressstart2plicense_txt extends haxe.io.Bytes {}
@:keep @:file("assets/data/lvl1.json") @:noCompletion #if display private #end class __ASSET__assets_data_lvl1_json extends haxe.io.Bytes {}
@:keep @:file("assets/data/lvl2room1.json") @:noCompletion #if display private #end class __ASSET__assets_data_lvl2room1_json extends haxe.io.Bytes {}
@:keep @:file("assets/data/lvl2room2.json") @:noCompletion #if display private #end class __ASSET__assets_data_lvl2room2_json extends haxe.io.Bytes {}
@:keep @:file("assets/data/lvl2room3.json") @:noCompletion #if display private #end class __ASSET__assets_data_lvl2room3_json extends haxe.io.Bytes {}
@:keep @:file("assets/data/lvl2room4.json") @:noCompletion #if display private #end class __ASSET__assets_data_lvl2room4_json extends haxe.io.Bytes {}
@:keep @:file("assets/data/lvl2room5.json") @:noCompletion #if display private #end class __ASSET__assets_data_lvl2room5_json extends haxe.io.Bytes {}
@:keep @:file("assets/data/lvl2room6.json") @:noCompletion #if display private #end class __ASSET__assets_data_lvl2room6_json extends haxe.io.Bytes {}
@:keep @:file("assets/data/lvl2room7.json") @:noCompletion #if display private #end class __ASSET__assets_data_lvl2room7_json extends haxe.io.Bytes {}
@:keep @:file("assets/data/lvl2room8.json") @:noCompletion #if display private #end class __ASSET__assets_data_lvl2room8_json extends haxe.io.Bytes {}
@:keep @:file("assets/data/lvl3room1.json") @:noCompletion #if display private #end class __ASSET__assets_data_lvl3room1_json extends haxe.io.Bytes {}
@:keep @:file("assets/data/lvl3room10.json") @:noCompletion #if display private #end class __ASSET__assets_data_lvl3room10_json extends haxe.io.Bytes {}
@:keep @:file("assets/data/lvl3room11.json") @:noCompletion #if display private #end class __ASSET__assets_data_lvl3room11_json extends haxe.io.Bytes {}
@:keep @:file("assets/data/lvl3room12.json") @:noCompletion #if display private #end class __ASSET__assets_data_lvl3room12_json extends haxe.io.Bytes {}
@:keep @:file("assets/data/lvl3room13.json") @:noCompletion #if display private #end class __ASSET__assets_data_lvl3room13_json extends haxe.io.Bytes {}
@:keep @:file("assets/data/lvl3room14.json") @:noCompletion #if display private #end class __ASSET__assets_data_lvl3room14_json extends haxe.io.Bytes {}
@:keep @:file("assets/data/lvl3room15.json") @:noCompletion #if display private #end class __ASSET__assets_data_lvl3room15_json extends haxe.io.Bytes {}
@:keep @:file("assets/data/lvl3room2.json") @:noCompletion #if display private #end class __ASSET__assets_data_lvl3room2_json extends haxe.io.Bytes {}
@:keep @:file("assets/data/lvl3room3.json") @:noCompletion #if display private #end class __ASSET__assets_data_lvl3room3_json extends haxe.io.Bytes {}
@:keep @:file("assets/data/lvl3room4.json") @:noCompletion #if display private #end class __ASSET__assets_data_lvl3room4_json extends haxe.io.Bytes {}
@:keep @:file("assets/data/lvl3room5.json") @:noCompletion #if display private #end class __ASSET__assets_data_lvl3room5_json extends haxe.io.Bytes {}
@:keep @:file("assets/data/lvl3room6.json") @:noCompletion #if display private #end class __ASSET__assets_data_lvl3room6_json extends haxe.io.Bytes {}
@:keep @:file("assets/data/lvl3room7.json") @:noCompletion #if display private #end class __ASSET__assets_data_lvl3room7_json extends haxe.io.Bytes {}
@:keep @:file("assets/data/lvl3room8.json") @:noCompletion #if display private #end class __ASSET__assets_data_lvl3room8_json extends haxe.io.Bytes {}
@:keep @:file("assets/data/lvl3room9.json") @:noCompletion #if display private #end class __ASSET__assets_data_lvl3room9_json extends haxe.io.Bytes {}
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
@:keep @:image("assets/images/Alligator_Sprite_Sheet.png") @:noCompletion #if display private #end class __ASSET__assets_images_alligator_sprite_sheet_png extends lime.graphics.Image {}
@:keep @:image("assets/images/Bat_Sprite_Sheet.png") @:noCompletion #if display private #end class __ASSET__assets_images_bat_sprite_sheet_png extends lime.graphics.Image {}
@:keep @:image("assets/images/beat_light (o).png") @:noCompletion #if display private #end class __ASSET__assets_images_beat_light__o__png extends lime.graphics.Image {}
@:keep @:image("assets/images/beat_light.png") @:noCompletion #if display private #end class __ASSET__assets_images_beat_light_png extends lime.graphics.Image {}
@:keep @:image("assets/images/cat_shield.png") @:noCompletion #if display private #end class __ASSET__assets_images_cat_shield_png extends lime.graphics.Image {}
@:keep @:image("assets/images/Cat_Sprite_Sheet.png") @:noCompletion #if display private #end class __ASSET__assets_images_cat_sprite_sheet_png extends lime.graphics.Image {}
@:keep @:image("assets/images/cat_wave.png") @:noCompletion #if display private #end class __ASSET__assets_images_cat_wave_png extends lime.graphics.Image {}
@:keep @:image("assets/images/Characters_Sprite_Sheet.png") @:noCompletion #if display private #end class __ASSET__assets_images_characters_sprite_sheet_png extends lime.graphics.Image {}
@:keep @:image("assets/images/charge.png") @:noCompletion #if display private #end class __ASSET__assets_images_charge_png extends lime.graphics.Image {}
@:keep @:image("assets/images/crosshair.png") @:noCompletion #if display private #end class __ASSET__assets_images_crosshair_png extends lime.graphics.Image {}
@:keep @:image("assets/images/Door.png") @:noCompletion #if display private #end class __ASSET__assets_images_door_png extends lime.graphics.Image {}
@:keep @:image("assets/images/enemy_bullet.png") @:noCompletion #if display private #end class __ASSET__assets_images_enemy_bullet_png extends lime.graphics.Image {}
@:keep @:image("assets/images/energy.png") @:noCompletion #if display private #end class __ASSET__assets_images_energy_png extends lime.graphics.Image {}
@:keep @:image("assets/images/Goblin_Sprite_Sheet.png") @:noCompletion #if display private #end class __ASSET__assets_images_goblin_sprite_sheet_png extends lime.graphics.Image {}
@:keep @:image("assets/images/health.png") @:noCompletion #if display private #end class __ASSET__assets_images_health_png extends lime.graphics.Image {}
@:keep @:file("assets/images/images-go-here.txt") @:noCompletion #if display private #end class __ASSET__assets_images_images_go_here_txt extends haxe.io.Bytes {}
@:keep @:image("assets/images/judge_sprites/great.png") @:noCompletion #if display private #end class __ASSET__assets_images_judge_sprites_great_png extends lime.graphics.Image {}
@:keep @:image("assets/images/judge_sprites/misfire.png") @:noCompletion #if display private #end class __ASSET__assets_images_judge_sprites_misfire_png extends lime.graphics.Image {}
@:keep @:image("assets/images/judge_sprites/ok.png") @:noCompletion #if display private #end class __ASSET__assets_images_judge_sprites_ok_png extends lime.graphics.Image {}
@:keep @:image("assets/images/judge_sprites/ooe.png") @:noCompletion #if display private #end class __ASSET__assets_images_judge_sprites_ooe_png extends lime.graphics.Image {}
@:keep @:image("assets/images/judge_sprites/perfect.png") @:noCompletion #if display private #end class __ASSET__assets_images_judge_sprites_perfect_png extends lime.graphics.Image {}
@:keep @:image("assets/images/large_bullet.png") @:noCompletion #if display private #end class __ASSET__assets_images_large_bullet_png extends lime.graphics.Image {}
@:keep @:image("assets/images/laser.png") @:noCompletion #if display private #end class __ASSET__assets_images_laser_png extends lime.graphics.Image {}
@:keep @:image("assets/images/magic_missile.png") @:noCompletion #if display private #end class __ASSET__assets_images_magic_missile_png extends lime.graphics.Image {}
@:keep @:image("assets/images/metronome.png") @:noCompletion #if display private #end class __ASSET__assets_images_metronome_png extends lime.graphics.Image {}
@:keep @:image("assets/images/mouse.png") @:noCompletion #if display private #end class __ASSET__assets_images_mouse_png extends lime.graphics.Image {}
@:keep @:image("assets/images/NotOctorok_Sprite_Sheet.png") @:noCompletion #if display private #end class __ASSET__assets_images_notoctorok_sprite_sheet_png extends lime.graphics.Image {}
@:keep @:image("assets/images/player.png") @:noCompletion #if display private #end class __ASSET__assets_images_player_png extends lime.graphics.Image {}
@:keep @:image("assets/images/Rock.png") @:noCompletion #if display private #end class __ASSET__assets_images_rock_png extends lime.graphics.Image {}
@:keep @:image("assets/images/shooter.png") @:noCompletion #if display private #end class __ASSET__assets_images_shooter_png extends lime.graphics.Image {}
@:keep @:image("assets/images/Slime_Sprite_Sheet.png") @:noCompletion #if display private #end class __ASSET__assets_images_slime_sprite_sheet_png extends lime.graphics.Image {}
@:keep @:image("assets/images/StriderShockwave.png") @:noCompletion #if display private #end class __ASSET__assets_images_stridershockwave_png extends lime.graphics.Image {}
@:keep @:image("assets/images/ticks/green.png") @:noCompletion #if display private #end class __ASSET__assets_images_ticks_green_png extends lime.graphics.Image {}
@:keep @:image("assets/images/ticks/green_e (o).png") @:noCompletion #if display private #end class __ASSET__assets_images_ticks_green_e__o__png extends lime.graphics.Image {}
@:keep @:image("assets/images/ticks/green_e (o2).png") @:noCompletion #if display private #end class __ASSET__assets_images_ticks_green_e__o2__png extends lime.graphics.Image {}
@:keep @:image("assets/images/ticks/green_e.png") @:noCompletion #if display private #end class __ASSET__assets_images_ticks_green_e_png extends lime.graphics.Image {}
@:keep @:image("assets/images/ticks/green_g.png") @:noCompletion #if display private #end class __ASSET__assets_images_ticks_green_g_png extends lime.graphics.Image {}
@:keep @:image("assets/images/ticks/green_o.png") @:noCompletion #if display private #end class __ASSET__assets_images_ticks_green_o_png extends lime.graphics.Image {}
@:keep @:image("assets/images/ticks/green_p.png") @:noCompletion #if display private #end class __ASSET__assets_images_ticks_green_p_png extends lime.graphics.Image {}
@:keep @:image("assets/images/ticks/green_p_e.png") @:noCompletion #if display private #end class __ASSET__assets_images_ticks_green_p_e_png extends lime.graphics.Image {}
@:keep @:image("assets/images/ticks/purple.png") @:noCompletion #if display private #end class __ASSET__assets_images_ticks_purple_png extends lime.graphics.Image {}
@:keep @:image("assets/images/ticks/purple_e (o).png") @:noCompletion #if display private #end class __ASSET__assets_images_ticks_purple_e__o__png extends lime.graphics.Image {}
@:keep @:image("assets/images/ticks/purple_e (o2).png") @:noCompletion #if display private #end class __ASSET__assets_images_ticks_purple_e__o2__png extends lime.graphics.Image {}
@:keep @:image("assets/images/ticks/purple_e.png") @:noCompletion #if display private #end class __ASSET__assets_images_ticks_purple_e_png extends lime.graphics.Image {}
@:keep @:image("assets/images/ticks/purple_g.png") @:noCompletion #if display private #end class __ASSET__assets_images_ticks_purple_g_png extends lime.graphics.Image {}
@:keep @:image("assets/images/ticks/purple_o.png") @:noCompletion #if display private #end class __ASSET__assets_images_ticks_purple_o_png extends lime.graphics.Image {}
@:keep @:image("assets/images/ticks/purple_p.png") @:noCompletion #if display private #end class __ASSET__assets_images_ticks_purple_p_png extends lime.graphics.Image {}
@:keep @:image("assets/images/ticks/purple_p_e.png") @:noCompletion #if display private #end class __ASSET__assets_images_ticks_purple_p_e_png extends lime.graphics.Image {}
@:keep @:image("assets/images/ticks/red.png") @:noCompletion #if display private #end class __ASSET__assets_images_ticks_red_png extends lime.graphics.Image {}
@:keep @:image("assets/images/ticks/red_e (o).png") @:noCompletion #if display private #end class __ASSET__assets_images_ticks_red_e__o__png extends lime.graphics.Image {}
@:keep @:image("assets/images/ticks/red_e (o2).png") @:noCompletion #if display private #end class __ASSET__assets_images_ticks_red_e__o2__png extends lime.graphics.Image {}
@:keep @:image("assets/images/ticks/red_e.png") @:noCompletion #if display private #end class __ASSET__assets_images_ticks_red_e_png extends lime.graphics.Image {}
@:keep @:image("assets/images/ticks/red_g.png") @:noCompletion #if display private #end class __ASSET__assets_images_ticks_red_g_png extends lime.graphics.Image {}
@:keep @:image("assets/images/ticks/red_o.png") @:noCompletion #if display private #end class __ASSET__assets_images_ticks_red_o_png extends lime.graphics.Image {}
@:keep @:image("assets/images/ticks/red_p.png") @:noCompletion #if display private #end class __ASSET__assets_images_ticks_red_p_png extends lime.graphics.Image {}
@:keep @:image("assets/images/ticks/red_p_e.png") @:noCompletion #if display private #end class __ASSET__assets_images_ticks_red_p_e_png extends lime.graphics.Image {}
@:keep @:image("assets/images/WASD.png") @:noCompletion #if display private #end class __ASSET__assets_images_wasd_png extends lime.graphics.Image {}
@:keep @:image("assets/images/WaterStrider_Sprite_Sheet.png") @:noCompletion #if display private #end class __ASSET__assets_images_waterstrider_sprite_sheet_png extends lime.graphics.Image {}
@:keep @:file("assets/music/music-goes-here.txt") @:noCompletion #if display private #end class __ASSET__assets_music_music_goes_here_txt extends haxe.io.Bytes {}
@:keep @:file("assets/music/stg1.wav") @:noCompletion #if display private #end class __ASSET__assets_music_stg1_wav extends haxe.io.Bytes {}
@:keep @:font("export/html5/obj/webfont/PRESSSTART2P.TTF") @:noCompletion #if display private #end class __ASSET__assets_pressstart2p_ttf extends lime.text.Font {}
@:keep @:file("assets/sounds/beat.wav") @:noCompletion #if display private #end class __ASSET__assets_sounds_beat_wav extends haxe.io.Bytes {}
@:keep @:file("assets/sounds/fire.mp3") @:noCompletion #if display private #end class __ASSET__assets_sounds_fire_mp3 extends haxe.io.Bytes {}
@:keep @:file("assets/sounds/fire_e.mp3") @:noCompletion #if display private #end class __ASSET__assets_sounds_fire_e_mp3 extends haxe.io.Bytes {}
@:keep @:file("assets/sounds/hit.mp3") @:noCompletion #if display private #end class __ASSET__assets_sounds_hit_mp3 extends haxe.io.Bytes {}
@:keep @:file("assets/sounds/kill.mp3") @:noCompletion #if display private #end class __ASSET__assets_sounds_kill_mp3 extends haxe.io.Bytes {}
@:keep @:file("assets/sounds/sounds-go-here.txt") @:noCompletion #if display private #end class __ASSET__assets_sounds_sounds_go_here_txt extends haxe.io.Bytes {}
@:keep @:image("assets/unused/M484BulletCollection1.png") @:noCompletion #if display private #end class __ASSET__assets_unused_m484bulletcollection1_png extends lime.graphics.Image {}
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
@:keep @:expose('__ASSET__assets_pressstart2p_ttf') @:noCompletion #if display private #end class __ASSET__assets_pressstart2p_ttf extends lime.text.Font { public function new () { #if !html5 __fontPath = "assets/PRESSSTART2P"; #else ascender = 1024; descender = 0; height = 1024; numGlyphs = 559; underlinePosition = -48; underlineThickness = 51; unitsPerEM = 1024; #end name = "Press Start 2P"; super (); }}
@:keep @:expose('__ASSET__flixel_fonts_nokiafc22_ttf') @:noCompletion #if display private #end class __ASSET__flixel_fonts_nokiafc22_ttf extends lime.text.Font { public function new () { #if !html5 __fontPath = "flixel/fonts/nokiafc22"; #else ascender = 2048; descender = -512; height = 2816; numGlyphs = 172; underlinePosition = -640; underlineThickness = 256; unitsPerEM = 2048; #end name = "Nokia Cellphone FC Small"; super (); }}
@:keep @:expose('__ASSET__flixel_fonts_monsterrat_ttf') @:noCompletion #if display private #end class __ASSET__flixel_fonts_monsterrat_ttf extends lime.text.Font { public function new () { #if !html5 __fontPath = "flixel/fonts/monsterrat"; #else ascender = 968; descender = -251; height = 1219; numGlyphs = 263; underlinePosition = -150; underlineThickness = 50; unitsPerEM = 1000; #end name = "Monsterrat"; super (); }}


#end

#if (openfl && !flash)

#if html5
@:keep @:expose('__ASSET__OPENFL__assets_font_ttf') @:noCompletion #if display private #end class __ASSET__OPENFL__assets_font_ttf extends openfl.text.Font { public function new () { __fromLimeFont (new __ASSET__assets_font_ttf ()); super (); }}
@:keep @:expose('__ASSET__OPENFL__assets_pressstart2p_ttf') @:noCompletion #if display private #end class __ASSET__OPENFL__assets_pressstart2p_ttf extends openfl.text.Font { public function new () { __fromLimeFont (new __ASSET__assets_pressstart2p_ttf ()); super (); }}
@:keep @:expose('__ASSET__OPENFL__flixel_fonts_nokiafc22_ttf') @:noCompletion #if display private #end class __ASSET__OPENFL__flixel_fonts_nokiafc22_ttf extends openfl.text.Font { public function new () { __fromLimeFont (new __ASSET__flixel_fonts_nokiafc22_ttf ()); super (); }}
@:keep @:expose('__ASSET__OPENFL__flixel_fonts_monsterrat_ttf') @:noCompletion #if display private #end class __ASSET__OPENFL__flixel_fonts_monsterrat_ttf extends openfl.text.Font { public function new () { __fromLimeFont (new __ASSET__flixel_fonts_monsterrat_ttf ()); super (); }}

#else
@:keep @:expose('__ASSET__OPENFL__assets_font_ttf') @:noCompletion #if display private #end class __ASSET__OPENFL__assets_font_ttf extends openfl.text.Font { public function new () { __fromLimeFont (new __ASSET__assets_font_ttf ()); super (); }}
@:keep @:expose('__ASSET__OPENFL__assets_pressstart2p_ttf') @:noCompletion #if display private #end class __ASSET__OPENFL__assets_pressstart2p_ttf extends openfl.text.Font { public function new () { __fromLimeFont (new __ASSET__assets_pressstart2p_ttf ()); super (); }}
@:keep @:expose('__ASSET__OPENFL__flixel_fonts_nokiafc22_ttf') @:noCompletion #if display private #end class __ASSET__OPENFL__flixel_fonts_nokiafc22_ttf extends openfl.text.Font { public function new () { __fromLimeFont (new __ASSET__flixel_fonts_nokiafc22_ttf ()); super (); }}
@:keep @:expose('__ASSET__OPENFL__flixel_fonts_monsterrat_ttf') @:noCompletion #if display private #end class __ASSET__OPENFL__flixel_fonts_monsterrat_ttf extends openfl.text.Font { public function new () { __fromLimeFont (new __ASSET__flixel_fonts_monsterrat_ttf ()); super (); }}

#end

#end
#end

#end
