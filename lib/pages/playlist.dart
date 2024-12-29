import 'package:flutter/material.dart';

class PlaylistPage extends StatefulWidget {
  const PlaylistPage({super.key});

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}
class _PlaylistPageState extends State<PlaylistPage> {
  bool is_creatingPlaylist = false;

  static const List<String> playlistTypes = ["Empty Playlist", "Filter Playlist"]; 
  int create_playlist_type = 0;


  void button_onCreatePlaylist() {
    setState(() {
      is_creatingPlaylist = true;
    });
  }
  void button_onCancelCreate() {
    setState(() {
      is_creatingPlaylist = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: const Text("PlayList"),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            if (is_creatingPlaylist) ...createPlaylistMenu() else createPlaylistButton(),
          ],
        ),
      ),
    );
  }

  // For creating new playlist
  Widget createPlaylistButton() {
    return Card(
      color: Theme.of(context).colorScheme.secondaryContainer,
      child: SizedBox(
        width: 64,
        height: 64,
        child: IconButton(
          onPressed: button_onCreatePlaylist, 
          icon: Icon(Icons.add),
        ),
      )
    );
  }
  List<Widget> createPlaylistMenu() {
    return [
      Card(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Create New Playlist",
                textScaler: TextScaler.linear(1.5),
              ),
              playlistTypeInput(),
            ],
          ),
        ),
      ),
      createPlaylistMenuTypes(),
    ];
  }
  Widget createPlaylistMenuTypes() {
    switch(create_playlist_type) {
      case 0: return EmptyPlaylistMenu(onCancel: button_onCancelCreate);
      case 1: return FilteredPlaylistMenu(onCancel: button_onCancelCreate);
      default: return Container();
    }
  }
  Widget playlistTypeInput() {
    return Row(
      children: [
        const Text("Playlist Type : "),
        DropdownButton(
          value: playlistTypes[create_playlist_type],
          items: [
            ...playlistTypes.map((playlist_type) => DropdownMenuItem<String>(
              value: playlist_type,
              child: Text(playlist_type),
            ))
          ],
          onChanged: (value) => setState(() {
            if (value == null) return;
            create_playlist_type = playlistTypes.indexOf(value);
          }),
        )
      ],
    );
  }
}

class Condition {
  int condition;
  int value;

  Condition(this.condition, this.value);
}

class EmptyPlaylistMenu extends StatelessWidget {
  EmptyPlaylistMenu({super.key, required this.onCancel});

  final VoidCallback onCancel;
  final TextEditingController list_name_controller = TextEditingController();

  void button_onCreatePlaylist() {
    
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Row(
              children: [
                Text("Playlist Name : "),
                SizedBox(
                  width: 256,
                  height: 40,
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Enter Name Here",
                    ),
                    controller: list_name_controller,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => {},
                  child: const Text("Create")
                ),
                TextButton(
                  onPressed: onCancel,
                  child: const Text("Cancel")
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class FilteredPlaylistMenu extends StatefulWidget {
  final VoidCallback onCancel;
  const FilteredPlaylistMenu({super.key, required this.onCancel});

  @override
  State<FilteredPlaylistMenu> createState() => _FilteredPlaylistMenuState();
}
class _FilteredPlaylistMenuState extends State<FilteredPlaylistMenu> {

  List<List<Condition>> condition_type = [];
  static const List<String> conditions = ["hasTag", "withoutTag", "hasAuthor", "withoutAuthor"];
  static const List<String> operators = ["And", "Or", "Not"];
  static List<Condition> defaultConditionSet = [Condition(0, -1)];

  void button_addConditionSet() {
    setState(() {
      condition_type.add(defaultConditionSet);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card();
  }

    Widget addConditionSetButton() {
    return TextButton(
      onPressed: button_addConditionSet, 
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          color: Theme.of(context).colorScheme.secondaryContainer,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add),
            Text("Add Condition Set")
          ],
        ),
      ),
    );
  }

  Widget topConditionMenu(int index) {
    return Card(
      color: Theme.of(context).colorScheme.secondaryContainer,
      child: Column(
        children: [
          ...condition_type[index].asMap().entries.map((entry) => bottomConditionMenu(index, entry.key))
        ],
      ),
    );
  }
  Widget bottomConditionMenu(int index_1, int index_2) {
    return Card(
      color: Theme.of(context).colorScheme.tertiaryContainer,
      child: Row(
        children: [
          DropdownButton(
            items: [
              ...conditions.map((condition) => DropdownMenuItem<String>(
                value: condition,
                child: Text(condition),
              ))
            ],
            onChanged: (a) => {},
          )
        ],
      ),
    );
  }
  List<Widget> filteredPlaylistCreation() {
    return [
      Text(
        "Playlist Filters : ",
        textScaler: TextScaler.linear(1.1),
      ),
      ...condition_type.asMap().entries.map((entry) => topConditionMenu(entry.key)),
      addConditionSetButton(),
    ];
  }
}