Current plan:

App Bar header will remain as is

Header
    use a sliver app bar to expand workout details
Body:
    Reorderable List of exercises - can reorder exercises when in reorder mode
    exercise header can't be rearranged
    this is an expandable widget with a reorderable list of sets inside
    long press on exercise widget to reorder
    plus button at the bottom of each "exercise" to add another set:
        -if all sets are deleted exercise gets deleted, or can delete all sets by swiping left

Bottom
    plus button on bottom left to add set - if adding in the middle of an  "exercise" it will be split


Rules for the exercise widget:
    different widgets for cardio and strength
    if completed, the tile will be uneditable 
    if completed and not selected, the tile will just show basic details - weight & reps
    if completed and selected, the title will show all details
    
    if current activity is currently selected all details are shown and editable with rest timer inside widget
    if current activity is not selected show all details and have rest timer and log option
    
    if activity is future and not selected, it will be the same as completed and not selected
    if activity is future and selected, all details will be editable and there will be a log option
        if log occurs, re arrange only the one set

    if there is a change to an editable set, all future sets that have the same exercise, weight and reps will be updated to reflect this

Hierarchy
    Reorderable Sliver List >
        "Dismissable Widget">
            "Exercises" >
                Exercise Header
                Dismissable Widgets >
                    Appropriate Set
                + button to add additional set to exercise