(**************************************************************************)
(*    Carto - TopoTeam                                                    *)
(**************************************************************************)

let num = ref 0

(* BEGIN -- Main and various functions for the GTK interface *)
let quit () =
	GMain.quit ();
	exit 0

let exec_fst_treat btn =
	Assist.winstep ();
	btn#misc#set_sensitive true

let exec_assist () =
	Assist.winalt ()

let exec_brow win b =
	Browser.browser win;
	b#misc#set_sensitive true

let main () =

	ignore (GtkMain.Main.init ());

	(* Recuperation de la taille de l'ecran *)
	let screen = Gdk.Screen.default () in
	let screen_hei = Gdk.Screen.height ~screen:screen () in
	let screen_wid = Gdk.Screen.width ~screen:screen () in

  	let w = GWindow.window
		~title:"Carto TopoTeam" ()
		~width:screen_wid
		~height:screen_hei
		~position:`CENTER in
	let vbox = GPack.vbox
		~packing:w#add () in

	(* Menu *)
	let menufile = GMenu.menu () in
	let mf_open = GMenu.menu_item
		~label:"Open image"
		~packing:menufile#append () in
	let mf_quit = GMenu.menu_item
		~label:"Quit"
		~packing:menufile#append () in
	let menubar = GMenu.menu_bar
		~packing:vbox#pack () in
	let item1 = GMenu.menu_item
		~label:"File"
		~packing:menubar#append () in
	item1#set_submenu menufile;

	let _lbl = GMisc.label
		~text:"Projet Carto -- Topo team"
		~packing:(vbox#pack ~expand:false ~fill:false) () in
	let _separator = GMisc.separator `HORIZONTAL
		~packing:(vbox#pack ~expand:false ~fill:false) () in
	let _lbl = GMisc.label
		~text:"\nEffectuer le pre traitement\navant de lancer l'assistant\n"
		~packing:(vbox#pack ~expand:false ~fill:false) () in
	let _lbl2 = GMisc.label
		~text:(Refe.get_filename ())
		~packing:(vbox#pack ~expand:false ~fill:false) () in
	let btn_browse = GButton.button
		~label:"Browse"
		~packing:(vbox#pack ~padding:5) () in
	let btn_pre_treat = GButton.button
		~label:"Execute"
		~packing:(vbox#pack ~padding:5) () in
	let btn_assist = GButton.button
		~label:"Assist"
		~packing:(vbox#pack ~padding:5) () in
	let btn_quit = GButton.button
		~label:"Quit"
	 	~packing:(vbox#pack ~padding:5) () in

	btn_pre_treat#misc#set_sensitive false;
	btn_assist#misc#set_sensitive false;

	(* --------- *)
	(* CALLBACKS *)
	(* --------- *)
	
	(*menu*)
	ignore (mf_open#connect#activate
		~callback:(fun () -> exec_brow w btn_pre_treat));
	ignore (mf_quit#connect#activate
		~callback:quit); 
	
	(*buttons*)
  	ignore (w#connect#destroy ~callback:GMain.quit);
	ignore (btn_browse#connect#clicked
		~callback:(fun () -> exec_brow w btn_pre_treat));
	ignore (btn_pre_treat#connect#clicked
		~callback:(fun () -> exec_fst_treat btn_assist));
	ignore (btn_assist#connect#clicked
		~callback:exec_assist);
	ignore (btn_quit#connect#clicked
		~callback:quit);

  	w#show ();
  	GMain.main ()

let _ = main ()