json.account @account
tmp = { 
	"series" => ['Completed', 'In Progress','Assigned'],
	"data" => [{
      "x" => "Today",
      "y" => [
      	@group_count['compl'], 
      	@group_count['wip'], 
      	@group_count['reg']
      ],
      "tooltip" => "this is tooltip"
    }]
}
json.activityChartData tmp
