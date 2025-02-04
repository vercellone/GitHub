class GitHubContextTransform : System.Management.Automation.ArgumentTransformationAttribute {

    [object] Transform([System.Management.Automation.EngineIntrinsics]$engineIntrinsics, [object]$inputData) {
        if ($inputData -is [string]) {
            try {
                $context = Get-GitHubContext -Context $inputData
                return $context
            }
            catch {
                # Ignore errors. $inputData will be returned unaltered
            }
        }

        return $inputData
    }
}
