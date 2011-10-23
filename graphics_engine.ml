(* Graphics engine *)

let width = 640
let height = 480
let rx = ref 0.0
let ry = ref 0.0
let rz = ref 0.0
let tx = ref 0.
let ty = ref 0.
let tz = ref (-10.)
let line = ref true
(*let liste = ref (((0.4, 0.6, 0.3), (20., 4., 3.))::
                 ((1.0, 1.0, 1.0), (1.0, 1.0, 0.0))::
                 ((0.0, 0.0, 1.0), (1.0, -1.0, 0.0))::
                 ((1.0, 1.0, 0.0), (20., 4., 3.))::
                 ((0.0, 1.0, 1.0), (1.0, 1.0, 0.0))::
                 ((1.0, 1.0, 1.0), (9.0, 4.0, 6.0))::
                 ((0.0, 1.0, 0.0), (20., 4., 3.))::
                 ((0., 1., 0.), (1.0, -1.0, 0.0))::
                 ((1., 0., 1.),(9., 4., 6.))::[])*)



let setup () =
  (* permettre le degrade de couleur *)
  GlDraw.shade_model `smooth;
  (* couleur de fond *)
  GlClear.color (0.0, 0.0, 0.0);
  (* profondeur *)
  GlClear.depth 10.;
  GlClear.clear [`color; `depth];
  Gl.enable `depth_test;
  GlFunc.depth_func `lequal;
  GlMisc.hint `perspective_correction `nicest


let rec create_tri = function
    [] -> ()
  | e::l -> GlDraw.color (snd e);
            GlDraw.vertex3 (fst e);
            create_tri l


(* affichage de la scene *)
let scene_gl () =
  (* precaution *)
  GlClear.clear [`color; `depth];
  (* creer une matrice *)
  GlMat.load_identity ();
  (* changement "d'origine" de la matrice *)
  GlMat.translate3 (!tx, !ty, !tz);
  (* translation *)
  GlMat.rotate3 !rx (2.0, 0.0, 0.0);
  GlMat.rotate3 !ry (0.0, 2.0, 0.0);
  GlMat.rotate3 !rz (0.0, 0.0, 2.0);
  (* Modifier le mode d'affichage *)
  if !line then
    (GlDraw.polygon_mode `front `line;
    GlDraw.polygon_mode `back `line)
  else
    (GlDraw.polygon_mode `front `fill;
    GlDraw.polygon_mode `back `fill);
  GlDraw.line_width 1.0;
  GlDraw.begins `triangles;
  create_tri (Refe.get_list_3d());
  GlDraw.ends ();
  Glut.swapBuffers ()(*;
  rx := !rx +. 5.;
  ry := !ry +. 5.;
  rz := !rz +. 5.*)


(* redimensionner et lancement du programme *)
let reshape ~w ~h =
  let ratio = (float_of_int w) /. (float_of_int h) in
    (* limite d'affichage *)
    GlDraw.viewport 0 0 w h;
    (* mode projection ? *)
    GlMat.mode `projection;
    (* chargement de la matrice identite *)
    GlMat.load_identity ();
    GluMat.perspective 45.0 ratio (0.1, 500.0);
    (* changement de mode ? *)
    GlMat.mode `modelview;
    GlMat.load_identity ()


(* fonction xor *)
let xor a b =
  if a = true then
    not b
  else
    b


let reset () =
  rx := 0.;
  ry := 0.;
  rz := 0.;
  tx := 0.;
  ty := 0.;
  tz := -10.


(* gestion des evenements du clavier *)
let keyboard_event ~key ~x ~y = match key with
    (* ESCAPE *)
    27 -> exit 0
  (* touche "i" *)
  | 105 -> rx := !rx +. 5.0
  (* touche "k" *)
  | 107 -> rx:= !rx -. 5.0
  (* touche "j" *)
  | 106 -> ry := !ry +. 5.0
  (* touche "l" *)
  | 108 -> ry := !ry -. 5.0
  (* touche "u" *)
  | 117 -> rz := !rz -. 5.0
  (* touche "o" *)
  | 111 -> rz := !rz +. 5.0
  (* touche "t" *)
  | 116 -> line := (xor !line true)
  (* touche "a" *)
  | 97  -> tx := !tx -. 5.0
  (* touche "d" *)
  | 100 -> tx := !tx +. 5.0
  (* touche "w" *)
  | 119 -> ty := !ty +. 5.0
  (* touche "s"*)
  | 115 -> ty := !ty -. 5.0
  (* touche "q" *)
  | 113 -> tz := !tz +. 5.0
  (* touche "e" *)
  | 101 -> tz := !tz -. 5.0
  (* touche "r" *)
  | 114 -> reset ()
  | _ -> ()


(* fonction d'idle *)
let idle () =
  scene_gl ()


let main_engine () =
    ignore (Glut.init Sys.argv);
    (* creation du mode d'affichage *)
    Glut.initDisplayMode ~alpha:true ~depth:true ~double_buffer:true ();
    (* Init de la fenetre, a remplacer par une fenetre gtk *)
    Glut.initWindowSize width height;
    ignore (Glut.createWindow "hello");
    (* creation de la scene *)
    Glut.displayFunc scene_gl;
    (* gestion du clavier *)
    Glut.keyboardFunc keyboard_event;
    Glut.reshapeFunc reshape;
    Glut.idleFunc(Some idle);
    setup ();
    Glut.mainLoop ()

(* let _ = main () *)
