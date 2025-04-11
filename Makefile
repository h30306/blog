LEETCODE_TEMPLATE_SCRIPT=./templates/leetcode/generate_template.sh
INTERVIEW_TEMPLATE_SCRIPT=./templates/interview/generate_template.sh
ALGORITHM_TEMPLATE_SCRIPT=./templates/algorithm/generate_template.sh

generate_template:
	@echo "Generating template for $(param)"
	@if [ "$(param)" = "leetcode" ]; then \
		bash $(LEETCODE_TEMPLATE_SCRIPT) $(args); \
	elif [ "$(param)" = "interview" ]; then \
		bash $(INTERVIEW_TEMPLATE_SCRIPT) $(args); \
	elif [ "$(param)" = "algorithm" ]; then \
		bash $(ALGORITHM_TEMPLATE_SCRIPT) $(args); \
	else \
		echo "Invalid parameter. Use 'leetcode' or 'interview'."; \
	fi
	@echo "Template generation complete."