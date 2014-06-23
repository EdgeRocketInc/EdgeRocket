json.account @account
tmp = { 
	"series" => ['Completed', 'In Progress','Assigned'],
	"data" => [{
      "x" => "Learning items completed to date",
      "y" => [
      	@group_count['compl'], 
      	@group_count['wip'], 
      	@group_count['reg']
      ],
      "tooltip" => "this is tooltip"
    }]
}
json.activityChartData tmp
